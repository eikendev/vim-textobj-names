if exists('g:loaded_textobj_names')
	finish
else
	let g:loaded_textobj_names = 1
endif

call textobj#user#plugin('names', {
\	'underscore': {
\		'*sfile*': expand('<sfile>:p'),
\		'select-a': 'a_', '*select-a-function*': 's:underscore_select_a',
\		'select-i': 'i_', '*select-i-function*': 's:underscore_select_i',
\	},
\	'minus': {
\		'*sfile*': expand('<sfile>:p'),
\		'select-a': 'a-', '*select-a-function*': 's:minus_select_a',
\		'select-i': 'i-', '*select-i-function*': 's:minus_select_i',
\	},
\	'hash': {
\		'*sfile*': expand('<sfile>:p'),
\		'select-a': 'a#', '*select-a-function*': 's:hash_select_a',
\		'select-i': 'i#', '*select-i-function*': 's:hash_select_i',
\	},
\	'slash': {
\		'*sfile*': expand('<sfile>:p'),
\		'select-a': 'a/', '*select-a-function*': 's:slash_select_a',
\		'select-i': 'i/', '*select-i-function*': 's:slash_select_i',
\	},
\	'at': {
\		'*sfile*': expand('<sfile>:p'),
\		'select-a': 'a@', '*select-a-function*': 's:at_select_a',
\		'select-i': 'i@', '*select-i-function*': 's:at_select_i',
\	},
\})

let s:inner_pattern = '[^a-zA-Z0-9]'

function! <SID>search_head(char, inner) abort
	if a:inner
		let l:pos = searchpos(s:inner_pattern, 'bcnW', line('.'))
	else
		let l:pos = searchpos('[^' . a:char . ']' . a:char . '\|[^a-zA-Z0-9' . a:char . ']', 'bcnW', line('.'))
	endif

	if l:pos[0] == 0
		let l:pos = [line('.'), 1]
	else
		let l:pos[1] = l:pos[1] + 1
	endif

	return [0] + l:pos + [0]
endfunction

function! <SID>search_tail(char, inner) abort
	if a:inner
		let l:pos = searchpos(s:inner_pattern, 'nzW', line('.'))
	else
		let l:pos = searchpos(a:char . '[^' . a:char . ']\|[^a-zA-Z0-9' . a:char . ']', 'nzW', line('.'))

		" In case we matched the first option, we have to adjust the position.
		if getline(l:pos[0])[l:pos[1] - 1] == a:char
			let l:pos[1] = l:pos[1] + 1
		endif
	endif

	if l:pos[0] == 0
		let l:pos = [line('.'), len(getline(line('.')))]
	else
		let l:pos[1] = l:pos[1] - 1
	endif

	return [0] + l:pos + [0]
endfunction

function! <SID>search_wrapper(char, inner) abort
	let l:head_pos = <SID>search_head(a:char, a:inner)
	let l:tail_pos = <SID>search_tail(a:char, a:inner)

	return ['v', l:head_pos, l:tail_pos]
endfunction

function! s:underscore_select_a()
	return <SID>search_wrapper('_', 0)
endfunction

function! s:underscore_select_i()
	return <SID>search_wrapper('_', 1)
endfunction

function! s:minus_select_a()
	return <SID>search_wrapper('-', 0)
endfunction

function! s:minus_select_i()
	return <SID>search_wrapper('-', 1)
endfunction

function! s:hash_select_a()
	return <SID>search_wrapper('#', 0)
endfunction

function! s:hash_select_i()
	return <SID>search_wrapper('#', 1)
endfunction

function! s:slash_select_a()
	return <SID>search_wrapper('/', 0)
endfunction

function! s:slash_select_i()
	return <SID>search_wrapper('/', 1)
endfunction

function! s:at_select_a()
	return <SID>search_wrapper('@', 0)
endfunction

function! s:at_select_i()
	return <SID>search_wrapper('@', 1)
endfunction
