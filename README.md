## Distribution::Common

Create an installable Distribution from common sources.

But really this serves to provide examples on how to create your own `Distribution` classes that don't
rely on a specific file system directory layout before being installed.

## Synopsis

    use Distribution::Common::Git;
    use Distribution::Common::Tar;
    use Distribution::Common::Directory;

    # a local path with a .git folder
    my $git-dist = Distribution::Common::Git.new($path.IO, :$force);

    # a file ending in .tar.gz
    my $tar-dist = Distribution::Common::Tar.new($path.IO, :$force);

    # a plain directory like Distribution::Path for brevity
    my $dir-dist = Distribution::Common::Directory.new($path.IO, :$force);

## Classes

### Distribution::Common::Tar

Installable `Distribution` from a `.tar.gz` archive

### Distribution::Common::Git

Installable `Distribution` from a local git repo. Because this is a directory it inclusion is meant to serve as
an example as `Distribution::Common::Directory` will handle this similarly. In the future however it could
support changing branches

### Distribution::Common::Directory

Essentially the built-in `Distribution::Path` but built around the `Distribution::Common` interface

## Roles

### Distribution::Common

The base for the various common distribution classes. Fulfills rakudo's `Distribution` role by providing its own
IO interface requirements (`Distribution::IO`) which do most of the actual work. It's main purpose is to fake `IO::Handle`
methods such as `open` and `close` for `IO`-like access to objects that don't need to be `.open` before being read.

### Distribution::IO

Like rakudo's own `Distribution`, but with an additional requirement, `ls-files`, to automatically handle
the setting of `$!meta{files}` for `Distribution::Common`

### Distribution::IO::Proc::Tar

### Distribution::IO::Proc::Git

Extract a single file from a distribution to memory. When `CompUnitRepository::Installation::Install.install` accesses
such files they are written directly to their install location instead of first using an intermediate temporary location

### Distribution::IO::Directory

Basically provides a recursive file listing and little else
