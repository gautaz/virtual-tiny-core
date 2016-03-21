#!/usr/bin/env bash

declare -A virtualbox_scancodes
virtualbox_scancodes['1']="02 82"; virtualbox_scancodes[$'\041']="2a 02 82 aa"
virtualbox_scancodes['2']="03 83"; virtualbox_scancodes['@']="2a 03 83 aa"
virtualbox_scancodes['3']="04 84"; virtualbox_scancodes['#']="2a 04 84 aa"
virtualbox_scancodes['4']="05 85"; virtualbox_scancodes['$']="2a 05 85 aa"
virtualbox_scancodes['5']="06 86"; virtualbox_scancodes['%']="2a 06 86 aa"
virtualbox_scancodes['6']="07 87"; virtualbox_scancodes['^']="2a 07 87 aa"
virtualbox_scancodes['7']="08 88"; virtualbox_scancodes['&']="2a 08 88 aa"
virtualbox_scancodes['8']="09 89"; virtualbox_scancodes['*']="2a 09 89 aa"
virtualbox_scancodes['9']="0a 8a"; virtualbox_scancodes['(']="2a 0a 8a aa"
virtualbox_scancodes['0']="0b 8b"; virtualbox_scancodes[')']="2a 0b 8b aa"
virtualbox_scancodes['-']="0c 8c"; virtualbox_scancodes['_']="2a 0c 8c aa"
virtualbox_scancodes['=']="0d 8d"; virtualbox_scancodes['+']="2a 0d 8d aa"
virtualbox_scancodes['q']="10 90"; virtualbox_scancodes['Q']="2a 10 90 aa"
virtualbox_scancodes['w']="11 91"; virtualbox_scancodes['W']="2a 11 91 aa"
virtualbox_scancodes['e']="12 92"; virtualbox_scancodes['E']="2a 12 92 aa"
virtualbox_scancodes['r']="13 93"; virtualbox_scancodes['R']="2a 13 93 aa"
virtualbox_scancodes['t']="14 94"; virtualbox_scancodes['T']="2a 14 94 aa"
virtualbox_scancodes['y']="15 95"; virtualbox_scancodes['Y']="2a 15 95 aa"
virtualbox_scancodes['u']="16 96"; virtualbox_scancodes['U']="2a 16 96 aa"
virtualbox_scancodes['i']="17 97"; virtualbox_scancodes['I']="2a 17 97 aa"
virtualbox_scancodes['o']="18 98"; virtualbox_scancodes['O']="2a 18 98 aa"
virtualbox_scancodes['p']="19 99"; virtualbox_scancodes['P']="2a 19 99 aa"
virtualbox_scancodes['[']="1a 9a"; virtualbox_scancodes['{']="2a 1a 9a aa"
virtualbox_scancodes[']']="1b 9b"; virtualbox_scancodes['}']="2a 1b 9b aa"
virtualbox_scancodes[$'\012']="1c 9c"
virtualbox_scancodes['a']="1e 9e"; virtualbox_scancodes['A']="2a 1e 9e aa"
virtualbox_scancodes['s']="1f 9f"; virtualbox_scancodes['S']="2a 1f 9f aa"
virtualbox_scancodes['d']="20 a0"; virtualbox_scancodes['D']="2a 20 a0 aa"
virtualbox_scancodes['f']="21 a1"; virtualbox_scancodes['F']="2a 21 a1 aa"
virtualbox_scancodes['g']="22 a2"; virtualbox_scancodes['G']="2a 22 a2 aa"
virtualbox_scancodes['h']="23 a3"; virtualbox_scancodes['H']="2a 23 a3 aa"
virtualbox_scancodes['j']="24 a4"; virtualbox_scancodes['J']="2a 24 a4 aa"
virtualbox_scancodes['k']="25 a5"; virtualbox_scancodes['K']="2a 25 a5 aa"
virtualbox_scancodes['l']="26 a6"; virtualbox_scancodes['L']="2a 26 a6 aa"
virtualbox_scancodes[';']="27 a7"; virtualbox_scancodes[':']="2a 27 a7 aa"
virtualbox_scancodes["'"]="28 a8"; virtualbox_scancodes['"']="2a 28 a8 aa"
virtualbox_scancodes['`']="29 a9"; virtualbox_scancodes['~']="2a 29 a9 aa"
virtualbox_scancodes['\']="2b ab"; virtualbox_scancodes['|']="2a 2b ab aa"
virtualbox_scancodes['z']="2c ac"; virtualbox_scancodes['Z']="2a 2c ac aa"
virtualbox_scancodes['x']="2d ad"; virtualbox_scancodes['X']="2a 2d ad aa"
virtualbox_scancodes['c']="2e ae"; virtualbox_scancodes['C']="2a 2e ae aa"
virtualbox_scancodes['v']="2f af"; virtualbox_scancodes['V']="2a 2f af aa"
virtualbox_scancodes['b']="30 b0"; virtualbox_scancodes['B']="2a 30 b0 aa"
virtualbox_scancodes['n']="31 b1"; virtualbox_scancodes['N']="2a 31 b1 aa"
virtualbox_scancodes['m']="32 b2"; virtualbox_scancodes['M']="2a 32 b2 aa"
virtualbox_scancodes[',']="33 b3"; virtualbox_scancodes['<']="2a 33 b3 aa"
virtualbox_scancodes['.']="34 b4"; virtualbox_scancodes['>']="2a 34 b4 aa"
virtualbox_scancodes['/']="35 b5"; virtualbox_scancodes['?']="2a 35 b5 aa"
virtualbox_scancodes[' ']="39 b9"

function machine_setup {
	local mname="$1"; shift
	local iso="$1"; shift
	local port="$1"; shift
	local mdisk="$(VBoxManage list systemproperties | awk -F ': +' '/^Default machine folder/{print $2}')/${mname}/${mname}.vdi"

 	VBoxManage createvm --name "${mname}" --ostype Linux26_64 --register
 	VBoxManage modifyvm "${mname}" --vram 10
 	VBoxManage storagectl "${mname}" --name SATA --add sata --controller IntelAhci --portcount 1 --bootable on
 	VBoxManage createhd --filename "${mdisk}" --size 512
 	VBoxManage storageattach "${mname}" --storagectl SATA --port 0 --type hdd --medium "${mdisk}"
 	VBoxManage storagectl "${mname}" --name IDE --add ide --bootable on
 	VBoxManage storageattach "${mname}" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "${iso}"
 	VBoxManage modifyvm "${mname}" --nic1 nat --nictype1 virtio
 	VBoxManage modifyvm "${mname}" --natpf1 "ssh,tcp,,${port},,22"
 	VBoxManage startvm "${mname}" --type headless
}

function machine_finalize {
	local mname="$1"; shift
	local archive="$1"; shift

	while VBoxManage list runningvms | grep -q "^\"${mname}\" {"; do sleep 1; done
	VBoxManage storagectl "${mname}" --name IDE --remove
	VBoxManage export "${mname}" --output "${archive}" --options manifest
	echo "$(pwd): ${archive}"
}

function machine_clean {
	local mname="$1"; shift

	if VBoxManage list vms | grep -Eq "^\"${mname}\""; then
		if VBoxManage list runningvms | grep -Eq "^\"${mname}\""; then
			VBoxManage controlvm "${mname}" poweroff
		fi
		VBoxManage unregistervm "${mname}" --delete
	fi
}

function write_console {
	local mname="$1"; shift

	while read line; do
		for (( i=0 ; i < ${#line} ; i++ )); do
			VBoxManage controlvm "${mname}" keyboardputscancode ${virtualbox_scancodes[${line:i:1}]}
		done
		VBoxManage controlvm "${mname}" keyboardputscancode ${virtualbox_scancodes[$'\012']}
	done
}
