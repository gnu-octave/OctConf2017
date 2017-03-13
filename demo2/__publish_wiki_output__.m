## Copyright (C) 2016-2017 Kai T. Ohlhus
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{outstr} =} __publish_wiki_output__ (@var{type}, @var{varargin})
##
## Internal function.
##
## The first input argument @var{type} defines the required strings
## (@samp{str}) or cell-strings (@samp{cstr}) in @var{varargin} in order
## to produce Markdown output, processible by Jekyll.
##
## @var{type} is one of
##
## @itemize @bullet
## @item
## @samp{output_file_extension} ()
## @item
## @samp{header} (title_str, intro_str, toc_cstr)
## @item
## @samp{footer} ()
## @item
## @samp{code} (str)
## @item
## @samp{code_output} (str)
## @item
## @samp{section} (str)
## @item
## @samp{preformatted_code} (str)
## @item
## @samp{preformatted_text} (str)
## @item
## @samp{bulleted_list} (cstr)
## @item
## @samp{numbered_list} (cstr)
## @item
## @samp{graphic} (str)
## @item
## @samp{html} (str)
## @item
## @samp{latex} (str)
## @item
## @samp{text} (str)
## @item
## @samp{bold} (str)
## @item
## @samp{italic} (str)
## @item
## @samp{monospaced} (str)
## @item
## @samp{link} (url_str, url_str, str)
## @item
## @samp{TM} ()
## @item
## @samp{R} ()
## @end itemize
## @end deftypefn

function outstr = __publish_wiki_output__ (type, varargin)
  outstr = feval (["do_" type], varargin{:});
endfunction

function outstr = do_output_file_extension ()
  outstr = ".wiki";
endfunction

function outstr = do_header (title_str, intro_str, toc_cstr)
  outstr = intro_str;
endfunction

function outstr = do_footer (m_source_str)
  outstr = ['<div class="toccolours mw-collapsible mw-collapsed">', ...
    "\nOctave source for grabcode, published with GNU Octave ", ...
    version(), "\n", ...
    '<div class="mw-collapsible-content">', ...
    do_code_output(["##### SOURCE BEGIN #####\n", m_source_str, ...
    "\n##### SOURCE END #####"]), ...
    "\n</div>\n</div>\n[[Category:Agora]]"];
endfunction

function outstr = do_code (str)
  outstr = ["\n<syntaxhighlight lang=\"octave\">", str, "</syntaxhighlight>\n"];
endfunction

function outstr = do_code_output (str)
  outstr = ["\n<syntaxhighlight lang=\"text\">", str, "</syntaxhighlight>\n"];
endfunction

function outstr = do_section (varargin)
  outstr = ["\n= ", varargin{1}, " =\n"];
endfunction

function outstr = do_preformatted_code (str)
  outstr = do_code (str);
endfunction

function outstr = do_preformatted_text (str)
  outstr = ["\n <nowiki>\n", str, "</nowiki>\n"];
endfunction

function outstr = do_bulleted_list (cstr)
  outstr = "\n";
  for i = 1:length(cstr)
    outstr = [outstr, "* ", cstr{i}, "\n"];
  endfor
  outstr = [outstr, "\n"];
endfunction

function outstr = do_numbered_list (cstr)
  outstr = "\n";
  for i = 1:length(cstr)
    outstr = [outstr, "# ", cstr{i}, "\n"];
  endfor
  outstr = [outstr, "\n"];
endfunction

function outstr = do_graphic (str)
  outstr = ["[[File:", str, "|thumb|center]]"];
endfunction

function outstr = do_html (str)
  outstr = str;
endfunction

function outstr = do_latex (str)
  outstr = "";
endfunction

function outstr = do_link (url_str, str)
  outstr = ["[", url_str," ", str, "]"];
endfunction

function outstr = do_text (str)
  outstr = ["\n", str, "\n"];
endfunction

function outstr = do_bold (str)
  outstr = ["'''", str, "'''"];
endfunction

function outstr = do_italic (str)
  outstr = ["''", str, "''"];
endfunction

function outstr = do_monospaced (str)
  outstr = ["<code>", str, "</code>"];
endfunction

function outstr = do_TM ()
  outstr = "&trade;";
endfunction

function outstr = do_R ()
  outstr = "&reg;";
endfunction
