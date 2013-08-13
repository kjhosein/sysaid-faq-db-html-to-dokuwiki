# Script to Convert SysAid Knowledge Base to DokuWiki

This Perl script connects to a database containing the 'faq' table from a SysAid database, extracts each row, extracts and converts PNG images inline 
(encoded in base64), and finally uses the HTML::WikiConverter::DokuWiki module to convert the extracted HTML to DokuWiki format.

## License

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Installation/Usage 

Simply place the script where you'd like the output to live. You'll need the following:
* Perl 5.10 (tested on a Red Hat/CentOS 6 system)
* Perl-DBI module
* HTML::WikiConverter Perl module
* HTML::WikiConverter::DokuWiki Perl module
* HTML::Strip Perl module
* MIME::Base64 Perl module

The script will output whatever PNG images it finds along with `.txt` files of each record (KB article) in DokuWiki format. Each txt file includes the category and sub-category at the top. Since images were base64-encoded and included inline, those were stripped out and replaced with "===== an image goes here =====".

It is up to you to create wiki pages and paste the contents of the txt files into the editor and then upload the images into the correct spots. The images are numbered numerically and with the article id, so you should be able to match them up with the correct article fairly easily.

## Author

Khalid J Hosein

Written August 2013

## To Do

- [ ] Admittedly this is a very raw script that hits the 80/20 rule. Needs 
re-factoring.
- [ ] Option to specify the output directory.
- [ ] Option to write output to a directory structure mirroring the top, second and 3rd-level categories. This may be useful for those organizing their DokuWiki wiki by namespaces.
- [ ] The 3rd-level category of the article (I had no need for it, so omitted it)
- [ ] This script may potentially be easily adpated to output different wiki formats by calling a different wiki 'dialect'. See the HTML::WikiConverter module for more info.

## Thanks

Thanks to David J. Iberri for writing the HTML::WikiConverter module: 
http://search.cpan.org/~diberri/HTML-WikiConverter/
