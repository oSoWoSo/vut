$ test -x /workspace/project/vut/vut && echo "OK"
OK
$ grep -E "^version=" /workspace/project/vut/vut
version="0.24b"
$ test -f /workspace/project/vut/vut.conf && echo "OK"
OK
$ grep -q "XBPS_DISTDIR" /workspace/project/vut/vut.conf && echo "OK"
OK
$ grep -q "list_arguments" /workspace/project/vut/arguments.list && echo "OK"
OK
$ grep -q "src_build" /workspace/project/vut/arguments.list && echo "OK"
OK
$ test -x /workspace/project/vut/vut-EBG.sh && echo "OK"
OK
$ test -x /workspace/project/vut/vut-GUM.sh && echo "OK"
OK
$ test -f /workspace/project/vut/README.md && echo "OK"
OK
$ grep -q "^## Requirements" /workspace/project/vut/README.md && echo "OK"
OK
$ grep -q "^## Usage" /workspace/project/vut/README.md && echo "OK"
OK
$ grep -q "^## Features" /workspace/project/vut/README.md && echo "OK"
OK
