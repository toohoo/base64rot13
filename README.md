# base64rot13
A simple perl script to hide executables and other security issues in attachments of Gmail and possibly others. Do a base64 "encrypting" and a following ROT13 character rotation.

Help script (Perl) used under Win to hide executables plain or packed in zip-files in attachments out of the eyes of Gmail, which would deny the attachment if it would "see" it.

The help message states:
```
b64r13.pl - Benutzung/Usage:[perl] b64r13.pl [-e|-d] [-o] (quelldatei/source) [(zieldatei/destination)]
-e       encode (default)
-d       decode
-o       overwrite existing
-h|help  diese Hilfe/this help
ext(encode) = .b64.r13 (if no dest set)
source ext .b64.r13 = action: decode
```
Automatic name destination-file (if not set), recognize already packed file on extension and set automatic decrypting it.
Requires a Perl installation. Works under Win, possibly works under Linux with small changes; not tested.
