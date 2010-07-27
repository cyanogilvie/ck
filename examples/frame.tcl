#!/usr/bin/env tclsh8.6
# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4

set here	[file dirname [file normalize [info script]]]
set parent	[file dirname $here]

lappend auto_path $parent

package require ck

frame .foo -border {
	ulcorner
	hline
	urcorner
	vline
	lrcorner
	hline
	llcorner
	vline
} -width 40 -height 10
#frame .foo -width 40 -height 10
pack .foo -fill both -expand true

#update idletasks
after 2000 [list set ::done 1]

vwait ::done
exit 0

