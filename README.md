# logos10-snap

## Troubleshooting

### System.AccessViolationException

If Logos crashes when starting, it may be due to a corrupted Library index. To confirm
you can start it from a terminal and see if you see this error near the end of the output:
```
$ logos10-unofficial
[...]
Fatal error. System.AccessViolationException: Attempted to read or write protect
ed memory. This is often an indication that other memory is corrupt.
[...]
```
Try removing the Library index using the following command, then restart the app normally.
```
$ logos10-unofficial.remove-library-index
```
