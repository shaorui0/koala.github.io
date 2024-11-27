---
title: Shell commands table
date: 2024-11-27 22:30:00
tags: [shell]
---
| **Category** | **Command** | **Sub-command** | **Description** |
| --- | --- | --- | --- |
| **File Operations and Text Processing** | `cat` | `cat filename` | Displays the contents of `filename`. |
|  |  | `cat file1 file2 > combined_file` | Concatenates `file1` and `file2` into `combined_file`. |
|  | `grep` | `grep "pattern" file` | Searches for "pattern" in `file`. |
|  |  | `grep -r "pattern" directory/` | Recursively searches for "pattern" in `directory` and its subdirectories. |
|  |  | `grep -i "pattern" file` | Searches for "pattern" in `file` case-insensitively. |
|  | `sed` | `sed 's/old/new/g' file` | Replaces all occurrences of "old" with "new" in `file`. |
|  |  | `sed -i '1d' file` | Deletes the first line of `file` in place. |
|  | `awk` | `awk -F"\\t" '{print $8}' file` | Prints the 8th column of a tab-separated `file`. |
|  |  | `awk '{sum += $1} END {print sum}' file` | Sums the first column of `file` and prints the total. |
|  | `sort` | `sort file` | Sorts the lines in `file` alphabetically. |
|  |  | `sort -t $'\\t' -k 2 file` | Sorts `file` based on the second tab-separated column. |
|  |  | `sort -t $'\\t' -rk 2 file` | Sorts `file` in reverse order based on the second tab-separated column. |
|  | `uniq` | `uniq file` | Removes duplicate lines from `file`. |
|  |  | `uniq -c file` | Counts the number of occurrences of each line in `file`. |
|  | `split` | `split -l 10000 file.txt` | Splits `file.txt` into smaller files with 10,000 lines each. |
|  | `wc` | `wc -l file` | Counts the number of lines in `file`. |
|  |  | `wc -w file` | Counts the number of words in `file`. |
|  | `join` | `join file1 file2` | Joins lines of `file1` and `file2` on a common field. |
|  | `head` | `head -n 100 filename` | Displays the first 100 lines of `filename`. |
|  | `tail` | `tail -n +1000 filename` | Displays lines starting from line 1000 of `filename`. |
| **Data Statistics and Analysis** | `xargs` | `ls | xargs grep "pattern"` |
|  | `tee` | `command | tee file` |
|  |  | `command | tee -a file` |
| **Compression and Archiving** | `gzip` | `gzip filename` | Compresses `filename` using the gzip algorithm. |
|  |  | `gzip -d filename.gz` | Decompresses `filename.gz`. |
|  | `tar` | `tar -cvf archive.tar /path/to/directory` | Creates a tar archive without compression. |
|  |  | `tar -zcvf archive.tar.gz /path/to/directory` | Creates a tar archive with gzip compression. |
|  |  | `tar -xf archive.tar -C /destination` | Extracts a tar archive to the specified destination. |
|  |  | `tar -xzf archive.tar.gz -C /destination` | Extracts a gzip-compressed tar archive to the specified destination. |
|  |  | `tar -cvf archive.tar /path --exclude=*log* --exclude=*data*` | Creates a tar archive while excluding files matching patterns. |
|  | `zip` | `zip archive.zip file1 file2` | Compresses `file1` and `file2` into `archive.zip`. |
|  |  | `zip -r archive.zip directory/` | Recursively compresses `directory` into `archive.zip`. |
| **Data Flow and Process Management** | `ps` | `ps aux --sort=-%mem` | Lists processes sorted by memory usage. |
|  |  | `ps -ef` | Displays all running processes. |
|  |  | `ps -eaf` | Another variant to display all processes. |
|  | `top` | `top` | Displays real-time system processes and resource usage. |
|  | `kill` | `kill -9 $pid` | Forcefully terminates a process with the specified PID. |
|  | `pgrep` | `pgrep process_name` | Searches for processes by name and returns their PIDs. |
|  | `bg` | `bg %job` | Resumes a suspended job in the background. |
|  | `jobs` | `jobs` | Lists active jobs in the current shell. |
|  | `nohup` | `nohup command > output.log 2>&1 &` | Runs `command` immune to hangups, redirecting output to `output.log` and running it in the background. |
| **Network and File Transfer** | `wget` | `wget <http://example.com/file.zip`> | Retrieves `file.zip` from the specified URL. |
|  |  | `wget -O output.txt <http://example.com/data`> | Downloads data from the specified URL and saves it as `output.txt`. |
|  | `scp` | `scp file.txt user@remote:/path/` | Securely copies `file.txt` to a remote host. |
|  |  | `scp -r /local/dir user@remote:/path/` | Securely copies a directory recursively to a remote host. |
|  | `netstat` | `netstat -tunpl \| grep [port]` | Lists listening ports and associated processes. |
|  |  | `netstat -nap \| grep [pid]` | Shows network connections for a specific PID. |
|  | `nc` (netcat) | `nc -zv host port` | Scans `host` on `port` to check if it's open. |
|  |  | `nc host port` | Connects to `host` on `port` for data transfer or communication. |
| **System Information and Monitoring** | `df` | `df -h` | Reports file system disk space usage in a human-readable format. |
|  |  | `df -T` | Shows the type of file system. |
|  | `du` | `du -h --max-depth=1` | Displays disk usage in a human-readable format, limited to one directory level. |
|  |  | `du -sh test_dir` | Shows the total disk usage of `test_dir`. |
|  | `iostat` | `iostat` | Reports CPU and I/O statistics for devices and partitions. |
| **File Search** | `find` | `find . -name "*.log"` | Searches for all `.log` files in the current directory and subdirectories. |
|  |  | `find /path -type f -size +100M` | Finds files larger than 100MB in `/path`. |
|  | `which` | `which gcc` | Locates the executable path for `gcc`. |
| **Permission Management** | `chmod` | `chmod u+r file` | Adds read permission for the user on `file`. |
|  |  | `chmod o-r file` | Removes read permission for others on `file`. |
|  |  | `chmod 755 script.sh` | Sets permissions to rwxr-xr-x for `script.sh`. |
|  | `chown` | `chown user:group file` | Changes ownership of `file` to `user` and `group`. |
|  |  | `chown -R user:group directory/` | Recursively changes ownership of `directory` and its contents to `user` and `group`. |
|  | `ls -l` | `ls -l` | Lists directory contents in long format, showing permissions and ownership. |
| **Other Tools** | `env` | `env` | Displays the current environment variables. |
|  |  | `env VAR=value command` | Sets an environment variable `VAR` to `value` for the duration of `command`. |
|  | `date` | `date` | Displays the current date and time. |
|  |  | `date +"%Y-%m-%d"` | Outputs the date in YYYY-MM-DD format. |
|  | `watch` | `watch -n 1 ls` | Executes `ls` every second, updating the display. |
|  | `alias` | `alias ll='ls -al'` | Creates an alias `ll` for `ls -al`. |
|  |  | `alias gs='git status'` | Creates an alias `gs` for `git status`. |
| **Advanced Tools** | `jq` | `jq '.' file.json` | Parses and formats JSON data from `file.json`. |
|  |  | `jq '.key' file.json` | Extracts the value of `key` from `file.json`. |
| **Network Configuration and Management** | `netplan` | `netplan apply` | Applies the network configuration defined in Netplan YAML files. |
|  | `ip` | `ip addr add 10.240.224.117/24 dev ens9f0` | Adds an IP address to the network interface `ens9f0`. |
|  |  | `ip route add default via 10.240.224.1` | Adds a default gateway route via `10.240.224.1`. |
|  |  | `ip a sh dev ens1f0` | Shows the address information for the device `ens1f0`. |
|  |  | `ip l s ens1f0 up` | Sets the link state of `ens1f0` to up. |
|  | `ifconfig` | `ifconfig up ens9f0` | Brings up the network interface `ens9f0`. |
|  |  | `ifconfig ens9f0` | Displays the configuration of the network interface `ens9f0`. |
| **Networking Utilities** | `nslookup` | `nslookup child-prc.intel.com` | Queries DNS to obtain domain name information for `child-prc.intel.com`. |
|  |  |  |  |