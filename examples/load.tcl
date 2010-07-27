#!/usr/bin/env tclsh8.6
# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4

set here	[file dirname [file normalize [info script]]]
set parent	[file dirname $here]

lappend auto_path $parent

package require ck

exit 0

