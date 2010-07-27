#!/usr/bin/env tclsh8.6
# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4

if {![info exists ::tcl::basekit]} {
	package require platform

	foreach platform [platform::patterns [platform::identify]] {
		set tm_path		[file join $env(HOME) .tbuild repo tm $platform]
		set pkg_path	[file join $env(HOME) .tbuild repo pkg $platform]
		if {[file exists $tm_path]} {
			tcl::tm::path add $tm_path
		}
		if {[file exists $pkg_path]} {
			lappend auto_path $pkg_path
		}
	}
}

set here	[file dirname [file normalize [info script]]]
set parent	[file dirname $here]

lappend auto_path $parent

package require ck

set res	[ck_dialog .foo "hello, world" "This is the body text" "Ok" "Cancel"]

set h	[open /tmp/res w]
puts $h "Got result: $res"
close $h

#vwait ::done

exit 0
