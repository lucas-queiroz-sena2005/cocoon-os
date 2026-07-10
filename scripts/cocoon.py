#!/usr/bin/env python3
import sys
import os
import re
import argparse
import time
import subprocess
try:
    import readline  # noqa: F401
except ImportError:
    pass

# --- TUI Helpers ---


def get_char():
    import termios
    import tty
    import os
    import time
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = os.read(fd, 1).decode('utf-8')
        if ch == '\x1b':
            os.set_blocking(fd, False)
            try:
                time.sleep(0.05)
                try:
                    ch += os.read(fd, 4).decode('utf-8', errors='ignore')
                except BlockingIOError:
                    pass
            finally:
                os.set_blocking(fd, True)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch


def interactive_menu(title, options, filterable=False, help_text=None, multi_select=False, initial_toggled=None, draw_box=True):
    search_query = ""
    selected = 0
    toggled = set(initial_toggled) if initial_toggled else set()

    while True:
        # Filter options
        if filterable and search_query:
            query = search_query.lower()
            filtered_options = [opt for opt in options if query in opt.lower()]
        else:
            filtered_options = options

        selected = max(0, min(selected, len(filtered_options) - 1))

        os.system('tput civis')  # hide cursor
        print('\033[H\033[J', end='')  # clear screen

        if draw_box:
            print(f"\033[1;35m╭{'─' * (len(title) + 2)}╮\033[0m")
            print(f"\033[1;35m│ \033[1;37m{title}\033[1;35m │\033[0m")
            print(f"\033[1;35m╰{'─' * (len(title) + 2)}╯\033[0m\n")
        else:
            print(title)

        if help_text:
            print(f"\033[90m{help_text}\033[0m\n")

        if filterable:
            print(
                f"  \033[1;36mSearch:\033[0m \033[1;37m{search_query}\033[5m_\033[0m\n")

        if not filtered_options:
            print("    \033[90m(No matches found)\033[0m")
        else:
            # Pagination
            start_idx = max(0, selected - 7)
            end_idx = min(len(filtered_options), start_idx + 15)
            if end_idx - start_idx < 15:
                start_idx = max(0, end_idx - 15)

            for i in range(start_idx, end_idx):
                opt = filtered_options[i]
                orig_idx = options.index(opt)

                prefix = ""
                if multi_select:
                    prefix = "\033[1;32m[x]\033[0m " if orig_idx in toggled else "\033[90m[ ]\033[0m "

                if i == selected:
                    print(
                        f"  \033[1;32m❯\033[0m {prefix}\033[1;37m{opt}\033[0m")
                else:
                    print(f"    {prefix}\033[90m{opt}\033[0m")

            if len(filtered_options) > 15:
                print(
                    f"\n    \033[90m... ({len(filtered_options)} items total)\033[0m")

        if multi_select:
            print(
                "\n\033[90m[ Space: Toggle ] [ Enter: Confirm Selections ] [ Esc: Exit ]\033[0m")
        else:
            print(
                "\n\033[90m[ ↑/↓: Navigate ] [ Enter: Select ] [ ←: Back ] [ Esc: Exit ]\033[0m")
            if not filterable:
                print(
                    "\033[90m[ k/j: Navigate ] [ l: Select ] [ h: Back ] (Vim Bindings)\033[0m")

        sys.stdout.flush()

        try:
            ch = get_char()
            # Navigation
            if ch in ('\x1b[A', '\x1bOA') or (not filterable and ch == 'k'):  # Up
                selected = max(0, selected - 1)
            elif ch in ('\x1b[B', '\x1bOB') or (not filterable and ch == 'j'):  # Down
                selected = min(len(filtered_options) - 1, selected + 1)
            # Space Toggle
            elif ch == ' ' and multi_select:
                if filtered_options:
                    orig_idx = options.index(filtered_options[selected])
                    if orig_idx in toggled:
                        toggled.remove(orig_idx)
                    else:
                        toggled.add(orig_idx)
            # Enter / Right
            elif ch in ('\r', '\n', '\x1b[C', '\x1bOC') or (not filterable and ch == 'l'):
                if multi_select:
                    os.system('tput cnorm')
                    print('\033[H\033[J', end='')
                    return list(toggled)
                else:
                    if not filtered_options:
                        continue
                    os.system('tput cnorm')
                    print('\033[H\033[J', end='')
                    return options.index(filtered_options[selected])
            # Back
            elif ch in ('\x1b[D', '\x1bOD') or (not filterable and ch == 'h'):
                os.system('tput cnorm')
                print('\033[H\033[J', end='')
                return None
            # Esc / Ctrl+C
            elif ch in ('\x1b', '\x03'):
                os.system('tput cnorm')
                print('\033[H\033[J', end='')
                return None
            # Backspace
            elif ch == '\x7f' or ch == '\b':
                if filterable:
                    search_query = search_query[:-1]
                    selected = 0
            elif filterable and len(ch) == 1 and ch.isprintable():
                search_query += ch
                selected = 0
        except Exception:
            os.system('tput cnorm')
            sys.exit(1)


def get_input(prompt):
    try:
        return input(f"\033[1;36m?\033[0m \033[1;37m{prompt}\033[0m").strip()
    except (KeyboardInterrupt, EOFError):
        print()
        return None


def success(msg):
    print(f"\033[1;32m✔\033[0m \033[1;37m{msg}\033[0m")


def error(msg):
    print(f"\033[1;31m✖\033[0m \033[1;31m{msg}\033[0m")


def pause(msg="Press Enter to continue..."):
    try:
        input(f"\n\033[90m{msg}\033[0m")
    except (KeyboardInterrupt, EOFError):
        pass

# --- Core Logic ---


def find_flake_root():
    curr = os.getcwd()
    while curr != '/':
        if os.path.exists(os.path.join(curr, 'flake.nix')):
            return curr
        curr = os.path.dirname(curr)
    error("Could not find flake.nix in current or parent directories.")
    sys.exit(1)


def get_all_modules(root, category_filter=None):
    modules_dir = os.path.join(root, 'modules')
    all_modules = {}
    for cat in sorted(os.listdir(modules_dir)):
        cat_path = os.path.join(modules_dir, cat)
        if not os.path.isdir(cat_path) or cat == 'hosts':
            continue
        if category_filter and cat not in category_filter:
            continue

        files = [f for f in os.listdir(cat_path) if f.endswith('.nix')]
        for f in sorted(files):
            attr = f"{cat}-{f[:-4]}"
            filepath = os.path.join(cat_path, f)

            with open(filepath, 'r') as file_obj:
                content = file_obj.read()

            has_home = "flake.homeModules" in content
            has_nixos = "flake.nixosModules" in content

            if has_home and has_nixos:
                mod_type = "both"
            elif has_home:
                mod_type = "home"
            else:
                mod_type = "nixos"

            all_modules[attr] = {
                "path": filepath,
                "type": mod_type,
                "category": cat
            }
    return all_modules


def rebuild_system(root):
    print('\033[H\033[J', end='')
    print("\033[1;36mStarting NixOS Rebuild...\033[0m\n")
    try:
        subprocess.run(["sudo", "nixos-rebuild", "switch",
                       "--flake", f"{root}#thinkpad"], check=True)
        print()
        success("System rebuilt successfully!")
    except subprocess.CalledProcessError:
        print()
        error("Rebuild failed. Check the logs above.")
    pause()
    return True


def commit_and_push(root):
    print('\033[H\033[J', end='')
    msg = get_input("Enter commit message (or press Enter to abort): ")
    if not msg:
        return False

    print("\n\033[1;36mExecuting git commands...\033[0m\n")
    try:
        subprocess.run(["git", "add", "."], cwd=root, check=True)
        subprocess.run(["git", "commit", "-m", msg], cwd=root, check=True)
        subprocess.run(["git", "push"], cwd=root, check=True)
        print()
        success("Changes committed and pushed!")
    except subprocess.CalledProcessError:
        print()
        error("Git operation failed.")
    pause()
    return True


def manage_host_modules(root, category_filter, menu_title):
    hosts_dir = os.path.join(root, 'modules', 'hosts')
    hosts = [d for d in os.listdir(hosts_dir) if os.path.isdir(
        os.path.join(hosts_dir, d))]
    if not hosts:
        error("No hosts found.")
        pause()
        return False

    host_idx = interactive_menu("Select Host", hosts)
    if host_idx is None:
        return False
    host = hosts[host_idx]
    host_file = os.path.join(hosts_dir, host, 'host.nix')

    if not os.path.exists(host_file):
        error(f"Host file not found: {host_file}")
        pause()
        return False

    all_modules = get_all_modules(root, category_filter)
    if not all_modules:
        error("No modules found in these categories.")
        pause()
        return False

    with open(host_file, 'r') as f:
        lines = f.readlines()

    module_names = list(all_modules.keys())
    options = []
    active_indices = set()

    for i, m in enumerate(module_names):
        mod_info = all_modules[m]
        target_home = f"self.homeModules.{m}"
        target_nixos = f"self.nixosModules.{m}"

        has_home = any(target_home in line for line in lines)
        has_nixos = any(target_nixos in line for line in lines)

        if has_home or has_nixos:
            active_indices.add(i)

        options.append(f"{m} \033[90m({mod_info['type']})\033[0m")

    selected_indices = interactive_menu(
        menu_title,
        options,
        filterable=True,
        multi_select=True,
        initial_toggled=active_indices,
        help_text=f"Editing modules for host: {host}"
    )

    if selected_indices is None:
        return False

    to_add = set(selected_indices) - active_indices
    to_remove = active_indices - set(selected_indices)

    if not to_add and not to_remove:
        return False

    # 1. Apply Removals
    new_lines = []
    for line in lines:
        remove_line = False
        for i in to_remove:
            m = module_names[i]
            if f"self.homeModules.{m}" in line or f"self.nixosModules.{m}" in line:
                remove_line = True
                break
        if not remove_line:
            new_lines.append(line)

    # 2. Apply Additions
    lines = new_lines
    new_lines = []

    # We need to inject the additions in the correct places.
    home_injections = []
    nixos_injections = []

    for i in to_add:
        m = module_names[i]
        mod_info = all_modules[m]

        if mod_info['type'] in ['both', 'home']:
            home_injections.append(f"              self.homeModules.{m}\n")
        if mod_info['type'] in ['both', 'nixos']:
            nixos_injections.append(f"      self.nixosModules.{m}\n")

    in_home_block = False
    in_home_imports = False
    in_nixos_block = False

    for line in lines:
        if "home-manager.users" in line:
            in_home_block = True
        if in_home_block and "imports = [" in line:
            in_home_imports = True

        # Inject home modules right before the closing bracket of home imports
        if in_home_block and in_home_imports and "];" in line and home_injections:
            new_lines.extend(home_injections)
            home_injections = []

        # Inject nixos modules right before the closing bracket of the main imports
        if "imports = [" in line and not in_home_block:
            in_nixos_block = True

        if in_nixos_block and not in_home_block and "];" in line and nixos_injections:
            new_lines.extend(nixos_injections)
            nixos_injections = []

        new_lines.append(line)

    with open(host_file, 'w') as f:
        f.writelines(new_lines)

    print('\033[H\033[J', end='')
    success(f"Batch update applied to {host}!")
    print(f"  \033[32mAdded:\033[0m {len(to_add)}")
    print(f"  \033[31mRemoved:\033[0m {len(to_remove)}")
    pause()
    return True


def create_module(root):
    while True:
        categories = [d for d in os.listdir(os.path.join(root, 'modules')) if os.path.isdir(
            os.path.join(root, 'modules', d)) and d not in ('hosts')]
        cat_idx = interactive_menu("Select Module Category", categories)
        if cat_idx is None:
            return False
        category = categories[cat_idx]

        while True:
            print('\033[H\033[J', end='')
            name = get_input(
                f"Enter module name in '{category}' (e.g. 'spotify') [Ctrl+C to go back]: ")
            if name is None:
                break
            if not name or not re.match(r'^[a-zA-Z0-9_-]+$', name):
                error("Invalid module name (only letters, numbers, -, _ allowed).")
                pause()
                continue

            types = [
                "Home Manager (User-level dotfiles and packages)",
                "NixOS (System-wide services and packages)",
                "Both (Combined system configuration and user dotfiles)"
            ]
            type_idx = interactive_menu("Select Module Type", types)
            if type_idx is None:
                break

            attr_name = f"{category}-{name}"
            filepath = os.path.join(root, 'modules', category, f"{name}.nix")

            if os.path.exists(filepath):
                error(f"Module '{filepath}' already exists!")
                pause()
                return False

            content = "{ pkgs, ... }: {\n"
            if type_idx in [1, 2]:
                content += f"  flake.nixosModules.{attr_name} = {{ pkgs, ... }}:\n"
                content += "  {\n    environment.systemPackages = with pkgs; [ ];\n  };\n\n"
            if type_idx in [0, 2]:
                content += f"  flake.homeModules.{attr_name} = {{ pkgs, ... }}:\n"
                content += "  {\n    home.packages = with pkgs; [ ];\n  };\n"
            content += "}\n"

            with open(filepath, 'w') as f:
                f.write(content)

            print('\033[H\033[J', end='')
            success(f"Created module at {filepath}")
            return True


def delete_module(root):
    all_modules = get_all_modules(root)
    if not all_modules:
        error("No modules found.")
        pause()
        return False

    module_names = list(all_modules.keys())
    mod_idx = interactive_menu(
        "Select Module to Delete", module_names, filterable=True)
    if mod_idx is None:
        return False

    module_name = module_names[mod_idx]
    filepath = all_modules[module_name]['path']

    print('\033[H\033[J', end='')
    confirm = get_input(f"Are you sure you want to delete {filepath}? (y/N): ")
    if confirm and confirm.lower() == 'y':
        if os.path.exists(filepath):
            os.remove(filepath)
            success(f"Deleted {filepath}")
            pause()
            return True
    return False


def main():
    root = find_flake_root()

    banner = """\033[1;36m
   ____
  / ___|___   ___ ___   ___  _ __
 | |   / _ \\ / __/ _ \\ / _ \\| '_ \\
 | |__| (_) | (_| (_) | (_) | | | |
  \\____\\___/ \\___\\___/ \\___/|_| |_|
\033[0m\033[1;35m      NixOS Configuration Manager\033[0m
"""

    while True:
        choices = [
            "Manage Apps & Tools",
            "Manage System & Themes",
            "Create a new Module",
            "Delete a Module",
            "Build System (nixos-rebuild)",
            "Commit & Push Changes"
        ]

        idx = interactive_menu(banner, choices, draw_box=False)

        if idx is None:
            print('\033[H\033[J', end='')
            sys.exit(0)

        if idx == 0:
            manage_host_modules(
                root, ['apps', 'cli', 'services'], "Manage Apps & Tools (Spacebar to toggle)")
        elif idx == 1:
            manage_host_modules(
                root, ['system', 'style', 'layout'], "Manage System & Themes (Spacebar to toggle)")
        elif idx == 2:
            create_module(root)
        elif idx == 3:
            delete_module(root)
        elif idx == 4:
            rebuild_system(root)
        elif idx == 5:
            commit_and_push(root)


if __name__ == '__main__':
    main()
