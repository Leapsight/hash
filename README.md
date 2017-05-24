# hash

The library implements various non-crypto hash functions.

[![Build Status](https://secure.travis-ci.org/fogfish/hash.svg?branch=master)](http://travis-ci.org/fogfish/hash)

## Inspiration 

Software development project requires various function to map a data to fixed size values. This library aggregates these function to single project allowing easy re-use across Erlang projects, using unified interface `hash:function(...)` and allowing the function-per-module development practice.  




## Getting started

The latest version of hash library is available at its master branch. All development, including new features and bug fixes, take place on the master branch using forking and pull requests as described in contribution guidelines.

### Installation

If you use `rebar` you can include `hash` library in your project with
```
{hash, ".*",
   {git, "https://github.com/fogfish/hash", {branch, master}}
}
```

### Usage

The library exposes _all_ hash function through exports of `hash` module. Just call required function with input data, e.g:
```
hash:fnv32("erlang").
```



## Supported hash functions


### `fnv` - Fowler–Noll–Vo 

The FNV hash was designed for fast hash table and checksum use, not cryptography. The library implements both variants (FNV-1, FNV-1a) of original function and its improved version proposed by Bret Mulvey (FNV-1m) suitable for hashing in text processing applications. 

```
-spec fnv32(_) -> integer().
-spec fnv32a(_) -> integer().
-spec fnv32m(_) -> integer().
-spec fnv64(_) -> integer().
-spec fnv64a(_) -> integer().
-spec fnv128(_) -> integer().
-spec fnv128a(_) -> integer().
```

### `seq` -  Additive Congruential Random Number (ACORN)

The additive congruential random number generator, This is a special case of a multiple recursive generator. It is used to generate identical sequences on any machine.

```
-spec seq31(integer()) -> integer().
-spec seq32(integer()) -> integer().
```

### `fold` - XOR folding

The function fold data structure to single integer using XOR.

```
-spec fold32(_) -> integer().
```

### `buz` - Cyclic polynomial (BuzHash)

The hash function is based on cyclic polynomial belongs to class of rolling hash functions. It has the benefit of avoiding multiplications, using barrel shifts instead. The popular applications are finger-printing, content sync. 


This hash function requires a state passing between calls. The usage request opaque state initialization.

```
-spec buz32(integer()) -> _.
```

Every consequent call request the previous state and element to hash, it returns hash value and new opaque state.
```
-spec buz32(_, _) -> {integer(), _}.
```

### `pbkdf2` - Password-Based Key Derivation Function 2

The function applies recursively a HMAC to password along with salt to produce a derived key usable as a cryptographic key in subsequent operations.

```
-spec pbkdf2(prf(), pass(), salt(), c(), dklen()) -> binary().
```

* `prf()` is a pseudo-random function (hash algorithm for [HMAC](http://erldocs.com/17.0/crypto/crypto.html?i=0&search=crypto:hma#hmac/3))
* `pass()` is the master password used for key derivation
* `salt()` is sequence of bits
* `c()` number of iterations to apply the function
* `dklen()` the length of desired derive key in bits


### `geo` - Geo Hash

The function subdivide the space into buckets using z-order curve. It allows to move geo-graphical coordinate domain to string domain, offering arbitrary precision (reducing the size by removing tail of string).

```
-spec geo(binary()) -> {lat(), lng()}.
-spec geo({lat(), lng()}) -> binary().
-spec geo(lat(), lng()) -> binary().
```  

### AWS Signature Version 4

The function implements [Signature Version 4](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html). 

```
-spec aws_v4(access(), secret(), token(), region(), service()) -> hash().
-spec aws_v4_sign(method(), host(), path(), query(), headers(), payload(), hash()) -> [headers()]
```

You need to seed a hash state with your AWS credentials
```erlang
Hash = hash:aws_v4(<<"YOURKEY">>, <<"YOURSECRET">>, 'us-east-1', 'es'),
```

The hash state is then used at each iteration to sign you HTTP request
```erlang
hash:aws_v4_sign(
   'POST',                                   %% http method
   "search-foo.us-east-1.es.amazonaws.com",  %% host 
   "/mypath",                                %% path
   [{version, 1}, {foo, <<"bar">>}],         %% query parameters  
   [{'Content-Type', <<"application/x-www-form-urlencoded">>}], %% list of http headers to sign
   <<"foo=bar">>,                            %% payload
   Hash).                                    %% hash state
```

## How to Contribute

`hash` is Apache 2.0 licensed and accepts contributions via GitHub pull requests.

### getting started

* Fork the repository on GitHub
* Read the README.md for build instructions

### commit message

The commit message helps us to write a good release note, speed-up review process. The message should address two question what changed and why. The project follows the template defined by chapter [Contributing to a Project](http://git-scm.com/book/ch5-2.html) of Git book.

>
> Short (50 chars or less) summary of changes
>
> More detailed explanatory text, if necessary. Wrap it to about 72 characters or so. In some contexts, the first line is treated as the subject of an email and the rest of the text as the body. The blank line separating the summary from the body is critical (unless you omit the body entirely); tools like rebase can get confused if you run the two together.
> 
> Further paragraphs come after blank lines.
> 
> Bullet points are okay, too
> 
> Typically a hyphen or asterisk is used for the bullet, preceded by a single space, with blank lines in between, but conventions vary here
>

## Bugs
If you detect a bug, please bring it to our attention via GitHub issues. Please make your report detailed and accurate so that we can identify and replicate the issues you experience:
- specify the configuration of your environment, including which operating system you're using and the versions of your runtime environments
- attach logs, screen shots and/or exceptions if possible
- briefly summarize the steps you took to resolve or reproduce the problem


## License

Copyright 2012 Dmitry Kolesnikov

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
