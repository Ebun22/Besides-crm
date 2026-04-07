import * as fs from 'fs';
import * as path from 'path';

const SOURCE_DIR = path.join(process.cwd(), 'supabase', 'schema');
const TARGET_DIR = path.join(process.cwd(), 'supabase', 'migrations');

/**
 * Removes the 3-digit prefix (e.g., "001_") from a string.
 */
const stripPrefix = (name: string): string => {
  return name.replace(/^\d{3}_?/, '');
};

/**
 * Generates a Supabase-compatible timestamp (YYYYMMDDHHMMSS)
 * adds 'offset' seconds to the current time.
 */
const getTimestamp = (offset: number): string => {
  const date = new Date();
  date.setSeconds(date.getSeconds() + offset);

  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  const hh = String(date.getHours()).padStart(2, '0');
  const mm = String(date.getMinutes()).padStart(2, '0');
  const ss = String(date.getSeconds()).padStart(2, '0');

  return `${y}${m}${d}${hh}${mm}${ss}`;
};

async function processMigrations() {
  if (!fs.existsSync(TARGET_DIR)) {
    fs.mkdirSync(TARGET_DIR, { recursive: true });
  }

  let fileCounter = 0;

  function walk(currentPath: string, folderParts: string[] = []) {
    const items = fs.readdirSync(currentPath, { withFileTypes: true });

    // Sort items to ensure we process them in the order of their prefixes
    items.sort((a, b) => a.name.localeCompare(b.name));

    for (const item of items) {
      const fullPath = path.join(currentPath, item.name);

      if (item.isDirectory()) {
        // Add stripped folder name to the chain
        walk(fullPath, [...folderParts, stripPrefix(item.name)]);
      }
      else if (item.name.endsWith('.sql')) {
        const strippedFileName = stripPrefix(item.name);
        const timestamp = getTimestamp(fileCounter);

        // Combine: timestamp + folder_names + file_name
        const newFileName = [
          timestamp,
          ...folderParts,
          strippedFileName
        ].join('_');

        const targetPath = path.join(TARGET_DIR, newFileName);

        // Copy the file
        fs.copyFileSync(fullPath, targetPath);
        console.log(`Created: ${newFileName}`);

        fileCounter++;
      }
    }
  }

  try {
    walk(SOURCE_DIR);
    console.log('\nMigration sync complete!');
  } catch (err: any) {
    console.error('Error processing files:', err.message);
  }
}

processMigrations();
