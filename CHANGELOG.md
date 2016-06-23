0.2.4 (24/06/2016)
---

- Client IP addresses in request list now reported correctly.
- Pot URLs will no longer be be generated with an incorrect port.

0.2.3 (23/06/2016)
---

- SECRET_KEY_BASE now requires RELX_REPLACE_OS_VARS=true to work.  v0.2.2
  did not seem to like the `{:system, SECRET_KEY_BASE}` setting that was used
  before.
  Technically this is a breaking change, but I'm the only user so never mind.

0.2.2 (23/06/2016)
---

- Fixes a regression in 0.2.0 & 0.2.1 where published releases did not contain
  minified javascript.

0.2.1 (23/06/2016)
---

- Add uuid to applications.  This was preventing builds from being made on
  0.2.0

0.2.0 (23/06/2016)
---

- Upgrade to elm 0.17
- Hook frontend up to backend via channels.
- Display correct URL on pot screen.
- Configure prod host & scheme properly.

0.1.2 (13/06/2016)
---

- Actually fixed building of frontend releases on travis.

0.1.1 (13/06/2016)
---

- Fixed building of frontend for releases on travis.  This means that there
  should be an actual frontend on rqstpot.xyz.

0.1.0 (08/06/2016)
---

- Initial Release.
- Request recording implemented.
- Pot creation & request listing API done.
- Individual request fetching still to do.
- UI is WIP.
