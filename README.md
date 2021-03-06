# base64rot13
A simple perl script to hide executables and other security issues in attachments of Gmail and possibly other e-mail services. Do a base64 "encrypting" and a following ROT13 character rotation. Same script for "decrypting".

**Attention**
This is not really an encryption, it has no keys for crypting and the 2 transformations are well known world wide. It is only for covering it from security-risk scanners and email attachment scanners.

The help script (Perl) used under Windows and Linux to hide executables plain or packed in zip-files in attachments out of the eyes of Gmail, which would deny the attachment if it would "see" it.

Call `baserot`/`baserot4` on command line/shell.    

For Linux change the home-dir of the pl-file in the shell script at line 7 in both `baserot`/`baserot4`.

The help message states:
```
baserot.pl - Benutzung/Usage:[perl] baserot.pl [-e|-d] [-o] (quelldatei/source) [(zieldatei/destination)]
-e       encode (default)
-d       decode
-o       overwrite existing
-h|help  diese Hilfe/this help
ext(encode) = .b64.r13 (if no dest set)
source ext .b64.r13 = action: decode
```
Automatic name for destination-file on encrypting (if not set), recognize already packed file on extension and set automatic decrypting mode. Automatic cover file-extensions known for executables (*.exe; *.com; *.bat; *.cmd; *.zip) from being recognized by renaming them on encrypting and doing the reverse on decrypting. ( *.zi_ and so on )
Requires a Perl installation. Works under Windows, possibly works under Linux with small changes; but this last was not tested.

## base64rot47
If someone needs a different rotation than ROT13 he can use this nearly equal script `baserot4`. The only difference is the rotation which is in concrete a ROT47 instead of a ROT13 here. If you're unsure what ROT47 is see [Wikipedia](https://en.wikipedia.org/wiki/ROT13#Variants).
