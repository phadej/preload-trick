This simple idea hit me when I was watching a talk about (dynamic) linking.  On
Linux (at least) we can `LD_PRELOAD` **own** shared objects, to override
symbols in other (maybe even proprietrary) shared objects. This is useful for
various purposes.  Can we do something like that in Haskell?

Not exactly, Haskell is not C. But, as the ecosystem is open, we can simply
vendor in the dependency (as source) and modify it. E.g. add some debug prints
to figure out why something doesn't work as expected? We *preload* on the
source level, i.e.  use the local version of package, not the one on the
Hackage.

However we don't need to stop there. We can mess with the vendored packages
as much as we need to. Imagine that we want to use `github` package,
but with `HsOpenSS`@ for encryption, not the `tls` package.

It turns out that we need to *mock* three packages:

- **http-client-tls:** This is obvious. `http-client-tls` relies on `tls` for TLS implementation.
  Luckily `github` uses only `tlsManagerSettings` which can be implemented
  as oneliner using `http-client-openssl`!

- **tls:** It turns out `github` doesn't use anything from `tls` directly.
  The dependency definition exists there to forbid old versions of
  `tls` (`git blame` points to commit that originally added `tls >=1.3.5` constrait.
  That version of `tls` has *Fix a bug with ECDHE based cipher where serialization*,
  I don't remember whether that is important or not, better to be safe).

- **cryptohash:** Here I can blame myself, somehow this (old) dependency
  sneaked in. I (as a maintainer of `github`) should use much lighter
  `cryptohash-sha1` package (or `cryptonite` directly, which I won't for this
  case).

All of the mocks are luckily very simple, `github` use only a very small
part of actual packages' APIs.

Is it worth it? Well... Maybe? At the very least, I learned about dependencies
of `github`. It depends on `cryptohash` for no reason.

Also if you carefully inspect *after* dependency graph, you notice that
`http-client` depends on `memory`! Looks like `http-client` uses
`Data.ByteString.Encoding` to do *Base64* encoding (in implementation of
`applyBasicAuth`).  I'd use `base64-bytestring` package for that purpose. So in
this exercise we could mock `memory` also, to only provide the *base64*
encoding. Or patch `http-client`.

In some sense this trick is *poor man's [Backpack](https://plv.mpi-sws.org/backpack/)*.
Hopefully this trick would be useful for someone, or actually hopefully
no one would ever need to rely on it.

### Dependency graphs:

**before**

<img src="https://raw.githubusercontent.com/phadej/preload-trick/master/deps-default.png" />

**after**

<img src="https://raw.githubusercontent.com/phadej/preload-trick/master/deps-preload.png" />
