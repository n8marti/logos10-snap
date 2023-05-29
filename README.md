# logos10-snap

## Troubleshooting

### System.AccessViolationException
```
Fatal error. System.AccessViolationException: Attempted to read or write protect
ed memory. This is often an indication that other memory is corrupt.
```
Try removing the Library index, then restart the app.
```bash
logos10-unofficial.remove-library-index
```
