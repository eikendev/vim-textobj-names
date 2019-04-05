if exists('g:loaded_textobj_names')
	finish
else
	let g:loaded_textobj_names = 1
endif

call textobj#user#plugin('things', {
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
\})

let s:border_chars_inc = '_\-#/'
let s:border_chars_exc = '[:space:][:punct:]'
let s:total_pattern = '\|^\|$\|[' . s:border_chars_exc . s:border_chars_inc . ']'

function! <SID>search_head(char, inner) abort
	let l:pos = searchpos(a:char . s:total_pattern, 'bcnW', line('.'))

	if a:inner
		if l:pos[1] != 1
			let l:pos = [l:pos[0], l:pos[1] + 1]
		endif
	else
		let l:matched_char = getline(l:pos[0])[l:pos[1] - 1]

		if l:matched_char =~ '[' . a:char . s:border_chars_inc . ']'
			" Do not change head.
			let l:pos = l:pos
		elseif l:matched_char =~ '[' . s:border_chars_exc . ']'
			let l:pos = [l:pos[0], l:pos[1] + 1]
		endif
	endif

	return [0] + l:pos + [0]
endfunction

function! <SID>search_tail(char, inner) abort
	" TODO Match a:char greedily.
	let l:pos = searchpos(a:char . s:total_pattern, 'nzW', line('.'))
	let l:line_len = len(getline(l:pos[0]))

	if l:pos[1] >= l:line_len
		" Limit the tail to the end of the line.
		let l:pos = [l:pos[0], l:line_len]
	elseif a:inner
		let l:pos = [l:pos[0], l:pos[1] - 1]
	else
		let l:matched_char = getline(l:pos[0])[l:pos[1] - 1]

		if l:matched_char =~ '[' . a:char . s:border_chars_inc . ']'
			" Do not change tail.
			let l:pos = l:pos
		elseif l:matched_char =~ '[' . s:border_chars_exc . ']'
			let l:pos = [l:pos[0], l:pos[1] - 1]
		elseif l:matched_char ==# ''
			" Prevent the next line from getting joined.
			let l:pos = [l:pos[0], l:pos[1] - 1]
		endif
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
