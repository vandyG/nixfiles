[sudo] password for vandy: 
warning: Git tree '/home/vandy/nixfiles' is dirty
building the system configuration...
warning: Git tree '/home/vandy/nixfiles' is dirty
Checking switch inhibitors... done
Traceback (most recent call last):
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 681, in <module>
    main()
    ~~~~^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 670, in main
    install_bootloader()
    ~~~~~~~~~~~~~~~~~~^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 507, in install_bootloader
    config_file += generate_config_entry(profile, gen, isFirst)
                   ~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 351, in generate_config_entry
    entry += config_entry(depth, boot_spec, f'Generation {gen}', str(time))
             ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 301, in config_entry
    entry += f'module_path: ' + get_kernel_uri(bootspec.initrd) + '\n'
                                ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 152, in get_kernel_uri
    return get_copied_path_uri(kernel_path, "kernels")
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 124, in get_copied_path_uri
    copy_file(path, dest_path)
    ~~~~~~~~~^^^^^^^^^^^^^^^^^
  File "/nix/store/3023a43jx5qf6y9gffziq7bbjak1dw92-limine-install.py", line 386, in copy_file
    shutil.copyfile(from_path, to_path + ".tmp")
    ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/nix/store/bw3yzin6hsy3xgl7hrlkf3nwyq4zp437-python3-3.13.13-env/lib/python3.13/shutil.py", line 273, in copyfile
    _fastcopy_sendfile(fsrc, fdst)
    ~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^
  File "/nix/store/bw3yzin6hsy3xgl7hrlkf3nwyq4zp437-python3-3.13.13-env/lib/python3.13/shutil.py", line 164, in _fastcopy_sendfile
    raise err from None
  File "/nix/store/bw3yzin6hsy3xgl7hrlkf3nwyq4zp437-python3-3.13.13-env/lib/python3.13/shutil.py", line 150, in _fastcopy_sendfile
    sent = os.sendfile(outfd, infd, offset, blocksize)
OSError: [Errno 28] No space left on device: '/nix/store/54gr9x75nyv1pshaswlz67mwks7gp0nm-initrd-linux-6.18.26/initrd' -> '/boot/limine/kernels/54gr9x75nyv1pshaswlz67mwks7gp0nm-initrd-linux-6.18.26-initrd.tmp'
Failed to install bootloader
Command 'systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER -E NIXOS_NO_CHECK --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration /nix/store/w3bn43ffgigaws2yxgapjf8hhymji6f2-nixos-system-vandy-26.11.20260610.9ae611a/bin/switch-to-configuration switch' returned non-zero exit status 1.
