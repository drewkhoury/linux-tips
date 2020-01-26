

**Kill process**

```
ps -ef | grep your_process_name | grep -v grep | awk '{print $2}' | xargs kill
```

# Chrome

More Tools > Task Manager > GPU Process

Chrome uses a GPU Process as standard, which means it speeds up the loading of web pages, which can be great except at times when your computer is struggling with insufficient RAM.


# Mac Memory

## Turn off spotlight
Disable spotlight: `sudo mdutil -a -i off`

## Virtual Memory stats

`vm_stat`

**Pages free**
the total number of free pages in the system.

**Pages active**
the total number of pages currently in use and pageable.

**Pages inactive**
the total number of pages on the inactive list.

**Pages wired down**
the total number of pages wired down. That is, pages that cannot
be paged out.

**Translation faults**
the number of times the “vm_fault” routine has been called.

**Pages copy-on-write**
the number of faults that caused a page to be copied (generally
caused by copy-on-write faults).

**Pages zero filled**
the total number of pages that have been zero-filled on demand.

**Pages reactivated**
the total number of pages that have been moved from the inactive
list to the active list (reactivated).

**Pageins**
the number of requests for pages from a pager (such as the inode
pager).

**Pageouts**
the number of pages that have been paged out.


## Activity Monitor

App memory: taken by apps and processes
Wired memory: reserved by apps, can’t be freed up
Compressed: inactive, can be used by other apps
Swap used: memory used by macOS
Cached files: memory you can really use

Notice the colored graph under Memory Pressure. 

If your graph is all but red and yellow, your Mac is really gasping for fresh memory. 

It seems counter-intuitive, but “available memory” your Activity Monitor is not that important after all. 

In fact, it’s a system intended behavior to use all memory resources when available. 

