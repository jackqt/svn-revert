# svn-revert
Revert missing files in SVN repository based on `svn revert` command
only support the specified svn missing file. But most of time, it only
need to assign a path include missing file to revert them.

## Usage
The `svn-revert.sh` script simply support `-h` as optional to find the
command usage:

```
$ svn-revert.sh -h  
Usage: revert.sh [-h] [PATH] [FILE]  
```

The script will find all the missing files in current directory if the
argument is empty:

```
$ svn-revert.sh  
Finding missing files in current SVN repo...  
Zero missing files in svn repo: .  
```

Else it will search the specify *PATH*/*FILE* argument if assigned,
list those files to ask you revert them or not:

```
$ svn-revert.sh path/to/revert  
Finding missing files in current SVN repo...  
SVN Missing files to be revert:  
    path/to/revert/file.name  
Do you wish to revert all these file? (y/n)y  
Reverting file: path/to/revert/file.name, continuing...  
Reverted 'path/to/revert/file.name'  
Missing files reverted in path: path/to/revert  
SVN status path/to/revert:  
```

## Fetch OR Download
This script stored in github.com, feel free to download it and use,
simply run command as below:

```
$ wget
https://github.com/jackqt/svn-revert/releases/download/1.0/svn-revert.sh  
$ mv svn-revert.sh /usr/local/bin  
$ chmod a+x /usr/local/bin/svn-revert.sh  
$ svn-revert.sh -h  
```

*NOTE: may need root user permission when move to /usr/local/bin
folder, and comfirm the path already been added into environment
variable PATH*
