import json
import os
import re
import time

def save_manifest(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4)

def clean_filename(text):
    text = text.replace(" ", "")
    text = re.sub(r'[\s\\/:*?"<>|]', '', text)
    return text

def main():
    manifest_path = "manifest.json"
    
    if not os.path.exists(manifest_path):
        print(f"error: '{manifest_path}' not found in this directory.")
        input("press Enter to exit...")
        return

    try:
        with open(manifest_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"error reading json: {e}")
        input("press Enter to exit...")
        return

    print("easy custom textures mod :: renaming tool")
    
    raw_id = input("what should the mod folder be called? (for example, redcardsmod)\n> ").strip()
    new_id = clean_filename(raw_id)
    
    if not new_id:
        print("mod folder name cannot be empty or contain only illegal characters")
        input("press Enter to exit...")
        return

    data["id"] = new_id
    save_manifest(manifest_path, data)

    display_name = input("what should the mod's display name be? (the name that is shown ingame)\n> ").strip()
    if not display_name:
        display_name = new_id
    data["name"] = display_name
    save_manifest(manifest_path, data)

    author = input("what name should show up for the mod's author? *optional\n> ").strip()
    if author:
        data["author"] = [author]
        data["prefix"] = clean_filename(author) + "_" + new_id
        save_manifest(manifest_path, data)
    else:
        data["prefix"] = new_id + ""
        save_manifest(manifest_path, data)

    description = input("what should the mod description be? *optional\n> ").strip()
    if description:
        data["description"] = description
        save_manifest(manifest_path, data)

    print("\n:: manifest.json updated successfully ::")

    current_dir = os.getcwd()
    parent_dir = os.path.dirname(current_dir)
    new_dir_path = os.path.join(parent_dir, new_id)
    
    os.chdir(parent_dir)
    
    while True:
        print(f"// attempting to rename folder to: {new_id}")
        try:
            os.rename(current_dir, new_dir_path)
            print("\nfinished!")
            time.sleep(3)
            break
        except Exception:
            print("\n[x] could not rename folder automatically (something might be open in another program)")
            input("press Enter to retry...")

if __name__ == "__main__":
    main()