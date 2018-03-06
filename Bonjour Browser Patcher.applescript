-- Bonjour Browser Patcher
-- Copyright (C) 2018 Jessica Stokes

-- find the current script or bundle
set scriptFolder to POSIX path of ((path to me as text) & "::")

-- find the Bonjour Browser application bundle
try
	-- NOTE: We shell out here so we don't get a GUI prompt to find an application to substitute for the one we're looking for
	set browserPath to do shell script "osascript -e \"POSIX path of (path to application \\\"Bonjour Browser\\\")\""
on error
	display alert (name of me) message "Bonjour Browser could not be found. Please download and install it from tildesoft.com and restart the patcher." as critical
	return
end try

-- let's find our patch file; we might be running as a script, or we might be an app bundle
try
	set patchPath to quoted form of (POSIX path of (path to resource "bonjour-browser.patch"))
on error
	-- fall back to "file adjacent to script" (not intended use case) if it's missing
	set patchPath to quoted form of (scriptFolder & "bonjour-browser.patch")
end try

on patchState of appPath against testPatchPath
	-- this is a handler explicitly because we need to squelch the error it produces
	-- and the only (clean?) way to do that seems to be with a return statement, so…
	try
		-- --dry-run will attempt to apply the patch but not write to disk!
		do shell script "cd \"" & appPath & "\" && cd .. && patch --dry-run -p1 -i " & testPatchPath
	on error errmsg
		return true
	end try
	
	return false
end patchState

-- at this point we know where the application bundle is, so let's determine if it's been patched yet
set alreadyPatched to patchState of browserPath against patchPath

-- set up dialog options. we begin with cancel
set optionsList to {"Cancel"}

-- and add more options based on whether the patch appears to be ready to rumble
-- as well as setting up the dialog text
if alreadyPatched then
	copy "Revert Patch" to the beginning of optionsList
	set alertMessage to "This will remove the patch from the copy of Bonjour Browser with updated services and names at " & browserPath & "."
else
	copy "Apply Patch" to the beginning of optionsList
	set alertMessage to "This will patch the copy of Bonjour Browser at " & browserPath & " with updated services and names."
end if

set task to display alert (name of me) message alertMessage & "

This is not provided by or affiliated in any way with tildesoft.com or Kevin Ballard.

For more information, see https://github.com/ticky/bonjour-browser-patcher" buttons optionsList

-- if the user canceled, bail out at the earliest point possible
if button returned of task is equal to "Cancel" then
	return
end if

-- we handle errors in the forward and reverse patch process with the same handler for brevity
-- any errors produced are likely to be the same as far as AppleScript is concerned, anyway
try
	if button returned of task is equal to "Apply Patch" then
		-- apply the patch file
		do shell script "cd \"" & browserPath & "\" && cd .. && patch -p1 -i " & patchPath
	else if button returned of task is equal to "Revert Patch" then
		-- apply the patch file (but in reverse!)
		do shell script "cd \"" & browserPath & "\" && cd .. && patch -p1 -R -i " & patchPath
	end if
on error errorMessage number errorNum
	-- if there's any non-zero exit code from the shell script, something went wrong
	-- patch's output isn't perfect but it's descriptive enough for now
	display alert (name of me & " Error (" & errorNum & ")") message "There was an error in the patch process. Output from the patch command:

	" & errorMessage as critical
	-- exit early if there was an error, so we don't get the "done" dialog
	return
end try

display alert (name of me) message "Done! Please restart Bonjour Browser." as informational
