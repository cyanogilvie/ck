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

package require cflib
package require sop

set here	[file dirname [file normalize [info script]]]
set parent	[file dirname $here]

lappend auto_path $parent

package require ck

option add *background	blue
option add *foreground	white
option add *Button.background	cyan
option add *Button.foreground	yellow
option add *Button.attributes	bold

. configure -background black

set boxborder {
	ulcorner
	hline
	urcorner
	vline
	lrcorner
	hline
	llcorner
	vline
}

set roundborder {
	/
	s1
	\\
	vline
	/
	s9
	\\
	vline
}
frame .foo -border $boxborder -height 10 -attributes bold
set labeldata	"hello, world"
#label .foo.l -textvariable labeldata -background #27abae -foreground #f6a44f
label .foo.s -text "?" -background black -attributes bold
label .foo.l -textvariable labeldata
label .foo.status -textvariable status -background white -foreground black
button .foo.b -text " Exit " -command {set ::done 1}
grid .foo.s -row 1 -column 1 -sticky e
grid .foo.l -row 2 -column 1
grid .foo.status -row 3 -column 1 -sticky ew -pady 1
grid .foo.b -row 4 -column 1
grid columnconfigure .foo 1 -weight 1

label .title -text " FNB Imaging Manager v0.99" -anchor w -foreground white -attributes dim -background black
label .bar -text " Status bar" -anchor w -foreground black -background white

grid .title -row 1 -column 1 -sticky ew
grid .foo -row 2 -column 1 -sticky ew -padx 2 -ipadx 1
grid .bar -row 3 -column 1 -sticky ew
grid rowconfigure . 2 -weight 1
grid columnconfigure . 1 -weight 1

bind .foo.status <Map> [list apply {
	{} {
		global status
		set w	[winfo width .foo.status]
		set status [string repeat * $w]
	}
}]


array set signals {}
sop::signal new signals(bounce)

array set toggles {}
sop::statetoggle new toggles(test) .foo.s \
		-text [list " NO  x " " YES o "] \
		-foreground {red green}
$toggles(test) attach_input $signals(bounce)

coroutine coro_poll apply {
	{} {
		global labeldata signals
		set seq	0
		while {1} {
			set afterid	[after 1000 [list [info coroutine] poll]]
			set rest	[lassign [yield] reason]

			switch -- $reason {
				poll {
					set labeldata	"hello, world update [incr seq]"
					$signals(bounce) toggle_state
				}

				default {
					puts stderr "Bad reason: ($reason)"
				}
			}
		}
	}
}


vwait ::done
exit 0

