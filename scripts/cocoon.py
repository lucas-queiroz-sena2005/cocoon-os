
import sys
import os
import re
import argparse
import time
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


def interactive_menu(title, options, filterable=False, help_text=None):
    search_query = ""
    selected = 0
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
        print(f"\033[1;35m╭{'─' * (len(title) + 2)}╮\033[0m")
        print(f"\033[1;35m│ \033[1;37m{title}\033[1;35m │\033[0m")
        print(f"\033[1;35m╰{'─' * (len(title) + 2)}╯\033[0m\n")

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
                if i == selected:
                    print(f"  \033[1;32m❯\033[0m \033[1;37m{opt}\033[0m")
                else:
                    print(f"    \033[90m{opt}\033[0m")

            if len(filtered_options) > 15:
                print(
                    f"\n    \033[90m... ({len(filtered_options)} items total)\033[0m")

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
            # Enter / Right
            elif ch in ('\r', '\n', '\x1b[C', '\x1bOC') or (not filterable and ch == 'l'):
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
                sys.exit(0)
            elif ch == '\x7f' or ch == '\b':  # Backspace
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
    error("Could not find flake.nix in current or parent directories. Are you inside the Cocoon OS repository?")
    sys.exit(1)


def get_all_modules(root):
    """
    Scans the modules directory and returns a dictionary:
    { "category-name": { "path": "/full/path.nix", "type": "nixos|home|both" } }
    """
    modules_dir = os.path.join(root, 'modules')
    all_modules = {}
    for cat in sorted(os.listdir(modules_dir)):
        cat_path = os.path.join(modules_dir, cat)
        if not os.path.isdir(cat_path) or cat == 'hosts':
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
                "type": mod_type
            }
    return all_modules


def create_module(root):
    while True:
        categories = [d for d in os.listdir(os.path.join(root, 'modules')) if os.path.isdir(
            os.path.join(root, 'modules', d)) and d not in ('hosts')]
        if not categories:
            print('\033[H\033[J', end='')
            error("No module categories found.")
            pause()
            return False

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

            while True:
                types = [
                    "Home Manager (User-level dotfiles and packages)",
                    "NixOS (System-wide services and packages)",
                    "Both (Combined system configuration and user dotfiles)"
                ]
                help_text = (
                    "Note: Home Manager modules run as your user.\n"
                    "NixOS modules run as root (system-wide)."
                )
                type_idx = interactive_menu(
                    "Select Module Type", types, help_text=help_text)
                if type_idx is None:
                    break

                attr_name = f"{category}-{name}"
                filepath = os.path.join(
                    root, 'modules', category, f"{name}.nix")

                if os.path.exists(filepath):
                    print('\033[H\033[J', end='')
                    error(f"Module '{filepath}' already exists!")
                    pause()
                    return False

                content = "{ pkgs, ... }: {\n"
                if type_idx in [1, 2]:  # System or Both
                    content += f"  flake.nixosModules.{attr_name} = {{ pkgs, ... }}:\n"
                    content += "  {\n    environment.systemPackages = with pkgs; [ ];\n  };\n\n"
                if type_idx in [0, 2]:  # Home or Both
                    content += f"  flake.homeModules.{attr_name} = {{ pkgs, ... }}:\n"
                    content += "  {\n    home.packages = with pkgs; [ ];\n  };\n"
                content += "}\n"

                with open(filepath, 'w') as f:
                    f.write(content)

                success(f"Created module at {filepath}")
                print(f"Attribute Name: \033[1;33m{attr_name}\033[0m")
                return True
            break


def list_modules(root):
    all_modules = get_all_modules(root)
    if not all_modules:
        print('\033[H\033[J', end='')
        error("No modules found.")
        pause()
        return False

    module_names = list(all_modules.keys())
    # Format options for the menu
    options = []
    for m in module_names:
        mod_type = all_modules[m]['type']
        options.append(f"{m} \033[90m({mod_type})\033[0m")

    # interactive_menu waits for a selection.
    # If they press Enter on a module, we can just return, since it's just a view.
    interactive_menu("Available Modules (Press Esc to go back)",
                     options, filterable=True)
    return False


def delete_module(root):
    while True:
        all_modules = get_all_modules(root)
        if not all_modules:
            print('\033[H\033[J', end='')
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
        confirm = get_input(
            f"Are you sure you want to delete {filepath}? (y/N): ")
        if confirm and confirm.lower() == 'y':
            if os.path.exists(filepath):
                os.remove(filepath)
                success(f"Deleted {filepath}")
                return True
            else:
                error(f"File not found: {filepath}")
                pause()
                return False
        else:
            return False


def modify_host(root, action):
    while True:
        hosts_dir = os.path.join(root, 'modules', 'hosts')
        hosts = [d for d in os.listdir(hosts_dir) if os.path.isdir(
            os.path.join(hosts_dir, d))]
        if not hosts:
            print('\033[H\033[J', end='')
            error("No hosts found.")
            pause()
            return False

        host_idx = interactive_menu(
            f"Select Host to {action.capitalize()}", hosts)
        if host_idx is None:
            return False
        host = hosts[host_idx]
        host_file = os.path.join(hosts_dir, host, 'host.nix')

        if not os.path.exists(host_file):
            print('\033[H\033[J', end='')
            error(f"Host file not found: {host_file}")
            pause()
            return False

        while True:
            all_modules = get_all_modules(root)
            if not all_modules:
                print('\033[H\033[J', end='')
                error("No modules found.")
                pause()
                return False

            with open(host_file, 'r') as f:
                lines = f.readlines()

            module_names = list(all_modules.keys())

            if action == 'add':
                filtered_module_names = []
                for m in module_names:
                    mod_info = all_modules[m]
                    target_home = f"self.homeModules.{m}"
                    target_nixos = f"self.nixosModules.{m}"

                    has_home = any(target_home in line for line in lines)
                    has_nixos = any(target_nixos in line for line in lines)

                    if mod_info['type'] == 'both':
                        if not has_home or not has_nixos:
                            filtered_module_names.append(m)
                    elif mod_info['type'] == 'home':
                        if not has_home:
                            filtered_module_names.append(m)
                    else:
                        if not has_nixos:
                            filtered_module_names.append(m)
                module_names = filtered_module_names

                if not module_names:
                    print('\033[H\033[J', end='')
                    error("All available modules are already added to this host.")
                    pause()
                    return False
            elif action == 'remove':
                filtered_module_names = []
                for m in module_names:
                    target_home = f"self.homeModules.{m}"
                    target_nixos = f"self.nixosModules.{m}"
                    has_home = any(target_home in line for line in lines)
                    has_nixos = any(target_nixos in line for line in lines)
                    if has_home or has_nixos:
                        filtered_module_names.append(m)
                module_names = filtered_module_names

                if not module_names:
                    print('\033[H\033[J', end='')
                    error("There are no modules currently added to this host.")
                    pause()
                    return False

            mod_idx = interactive_menu(
                f"Select Module to {action.capitalize()}", module_names, filterable=True)
            if mod_idx is None:
                break
            module_name = module_names[mod_idx]
            mod_info = all_modules[module_name]

            # Auto-detect type
            is_home = None
            if action == 'add':
                if mod_info['type'] == 'both':
                    while True:
                        types = []
                        target_home = f"self.homeModules.{module_name}"
                        target_nixos = f"self.nixosModules.{module_name}"
                        has_home = any(target_home in line for line in lines)
                        has_nixos = any(target_nixos in line for line in lines)

                        if not has_home:
                            types.append("Home Manager (User)")
                        if not has_nixos:
                            types.append("NixOS (System)")

                        type_idx = interactive_menu(
                            "Which module type?", types)
                        if type_idx is None:
                            break
                        selected_type = types[type_idx]
                        is_home = (selected_type == "Home Manager (User)")
                        break
                    if is_home is None:
                        continue  # They pressed Back during type selection
                else:
                    is_home = (mod_info['type'] == 'home')

            if action == 'add':
                target_string = f"self.homeModules.{module_name}" if is_home else f"self.nixosModules.{module_name}"

                if any(target_string in line for line in lines):
                    print('\033[H\033[J', end='')
                    error(
                        f"Module '{target_string}' is already imported in {host}.")
                    pause()
                    break

                in_home_block = False
                in_nixos_block = False
                in_imports = False
                inserted = False

                new_lines = []
                for line in lines:
                    if "home-manager.users" in line:
                        in_home_block = True
                    if in_home_block and "imports = [" in line:
                        in_imports = True
                    if in_home_block and in_imports and "];" in line and is_home and not inserted:
                        new_lines.append(f"              {target_string}\n")
                        inserted = True

                    if "# System-level modules" in line or "# Hardware/Dev features" in line:
                        in_nixos_block = True
                    if in_nixos_block and "];" in line and not is_home and not inserted:
                        new_lines.append(f"      {target_string}\n")
                        inserted = True

                    new_lines.append(line)

                if not inserted:
                    print('\033[H\033[J', end='')
                    error("Could not find the correct injection point in host.nix.")
                    pause()
                    return False

                with open(host_file, 'w') as f:
                    f.writelines(new_lines)
                success(f"Added {target_string} to {host}")
                return True

            elif action == 'remove':
                target_home = f"self.homeModules.{module_name}"
                target_nixos = f"self.nixosModules.{module_name}"

                removed = False
                new_lines = []
                for line in lines:
                    if target_home in line or target_nixos in line:
                        removed = True
                    else:
                        new_lines.append(line)

                if not removed:
                    print('\033[H\033[J', end='')
                    error(f"Module '{module_name}' is not imported in {host}.")
                    pause()
                    break

                with open(host_file, 'w') as f:
                    f.writelines(new_lines)
                success(f"Removed '{module_name}' from {host}")
                return True


def main():
    parser = argparse.ArgumentParser(description="Cocoon OS Manager")
    parser.add_argument('command', nargs='?', choices=[
                        'module', 'host'], help="Resource to manage")
    parser.add_argument('action', nargs='?', choices=[
                        'create', 'list', 'add', 'remove'], help="Action to perform")

    args, unknown = parser.parse_known_args()
    root = find_flake_root()

    if not args.command and not args.action:
        # Interactive mode loop
        while True:
            choices = ["Create a new Module", "List available Modules",
                       "Add Module to Host", "Remove Module from Host",
                       "Delete a Module"]
            idx = interactive_menu("Cocoon OS Manager", choices)

            if idx is None:
                print('\033[H\033[J', end='')
                break

            did_work = False
            if idx == 0:
                did_work = create_module(root)
            elif idx == 1:
                did_work = list_modules(root)
            elif idx == 2:
                did_work = modify_host(root, 'add')
            elif idx == 3:
                did_work = modify_host(root, 'remove')
            elif idx == 4:
                did_work = delete_module(root)

            if did_work:
                time.sleep(1.5)

        sys.exit(0)

    if args.command == 'module' and args.action == 'create':
        create_module(root)
    elif args.command == 'module' and args.action == 'list':
        list_modules(root)
    elif args.command == 'host' and args.action == 'add':
        modify_host(root, 'add')
    elif args.command == 'host' and args.action == 'remove':
        modify_host(root, 'remove')
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
