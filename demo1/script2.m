%% publish your Code with GNU Octave
%
% The <octave:publish publish> function was added to
% <https://www.gnu.org/software/octave *GNU Octave*> 4.2.0 back in last
% November.  This file should demonstrate some of it's functionality.
%
%%

%% First steps - text blocks, titles, and sections
%
% Using |publish|, each text block starts with two comment characters (|#| or
% |%|).  Each directly following comment line will be part of that text block.
% For example
%
%   %%         %%%        ##
%   % this,    % this,    # and this
%   %          %          #
%
% are perfect text blocks, without any difference.
%
% Additionally, it is possible to group your published document into sections.
% Therefore, just add a title to your text block:
%
%   %% Section title
%   %
%
% A text block without section title is a continuation of the previous section.
% 



%% Code evaluation with display of output
%
% The most powerful feature of the |publish| function is the automatic
% evaluation of all Octave code, that is not contained in a text block.
% Just enter the Octave code as always and the code will be presented with
% syntax highlighting and any output, textual or plots, will be presented
% below.
%
% For example the code:
%
%   x = 0:0.2:2*pi;
%   y = sin (x);
%   plot (x, y);     # Plot some sine
%   [x(end), y(end)] # Display the last point
%
% will produce the output:
%

x = 0:0.2:2*pi;
y = sin (x);
plot (x, y);     # Plot some sine
[x(end), y(end)] # Display the last point


%% Text block formatting
%
% The rest of this document is devoted to the formatting features of the
% |publish| function.
%



%% Bold, italic, and monospaced text
%
% Type &#42;BOLD TEXT&#42; for *BOLD TEXT*.
%
% Type &#95;ITALIC TEXT&#95; for _ITALIC TEXT_.
%
% Type &#124;MONOSPACED TEXT&#124; for |MONOSPACED TEXT|.
%



%% Hyperlinks
%
% There are three types of hyperlinks.
%
% 1. A hyperlink <https://www.gnu.org/software/octave> where label and URL are
% identical.  Created by:
%
%  &lt;https://www.gnu.org/software/octave>
%
% 2. A hyperlink <https://www.gnu.org/software/octave GNU Octave> where label
% and URL are different.  Created by:
%
%  &lt;https://www.gnu.org/software/octave GNU Octave>
%
% 3. Referring to a specific Octave function by an hyperlink to the online
% manual.  For <octave:plot Octave's plot function> just type:
%
%  &lt;octave:plot Octave's plot function>
%



%% Trademark symbols
%
% Type |(||TM)| to get (TM) and type |(||R)| to get (R).
%



%% Bulleted lists
%
% The input, sourrounded by empty text block lines
%
%  * ITEM 1
%  * ITEM 2
%  * ITEM 3
%  * ITEM 4
%
% will produce a bulleteded list:
% 
% * ITEM 1
% * ITEM 2
% * ITEM 3
% * ITEM 4
%



%% Numbered lists
%
% The input, sourrounded by empty text block lines
%
%  # ITEM 1
%  # ITEM 2
%  # ITEM 3
%  # ITEM 4
%
% will produce a bulleteded list:
% 
% # ITEM 1
% # ITEM 2
% # ITEM 3
% # ITEM 4
%


%% Preformatted text
%
% A text block line starting with two spaces and an empty preceding text block
% line will be seen as preformatted text and printed verbatim as is:
%
%  "To be, or not to be: that is the question:
%  Whether 'tis nobler in the mind to suffer
%  The slings and arrows of outrageous fortune,
%  Or to take arms against a sea of troubles,
%  And by opposing end them?  To die: to sleep;"
%
%  --"Hamlet" by W. Shakespeare
%


%% Octave Code
%
% A text block line starting with three spaces and an empty preceding text
% block line will be seen as Octave code and printed verbatim as is with
% syntax highlighting:
%
%   for i = 1:10
%     disp (x)
%   endfor
%



%% Include Octave code files
%
% To display the verbatim and syntax highlighted content of an Octave code file,
% no matter if function, class, or script, one can use the |<include>| tag.
% For example to include the content of a file named |script.m|, just type:
%
%  &lt;include>script.m&lt;/include>
%
% to see it's content:
%
% <include>script.m</include>
%



%% Include graphics
%
% To include a graphic, say |img.png|, just type:
%
%  &lt;&lt;img.png>>
%
% and make sure, that output document can find this graphic.
%



%% LaTeX formulae
%
% To display LaTeX set formulae, just sourround the formular by a single dollar
% sign |&#36;| for an inline equation, for example
% $e^{x} = \sum_{k = 0}^{\infty} \frac{x^{k}}{k!}$ or by two dollar signs |$$|
% for block display:
%
% $$e^{x} = \sum_{k = 0}^{\infty} \frac{x^{k}}{k!}$$.
%
% For HTML documents, the formulae are rendered by
% <https://www.mathjax.org MathJax>.
%


%% HTML Markup
%
% If the output is an HTML document, the content enclosed by the |&lt;html>| tag
% is printed as is.  This is useful, if it is desired to tweek the output with
% native HTML markup.  For other output formats, this markup is ignored.
%
% In an HTML document, this markup
%
%  &lt;html>
%  &lt;table>&lt;tr>
%  &lt;td style="border: 1px solid black;">one&lt;/td>
%  &lt;td style="border: 1px solid black;">two&lt;/td>
%  &lt;/tr>&lt;/table>
%  &lt;/html>
%
% will create a nice looking table:
%
% <html>
% <table><tr>
% <td style="border: 1px solid black;">one</td>
% <td style="border: 1px solid black;">two</td>
% </tr></table>
% </html>
%



%% LaTeX Markup
%
% If the output is a PDF or LaTeX document, the content enclosed by the
% |&lt;latex>| tag is printed as is.  This is useful, if it is desired to tweek
% the output with native LaTeX markup.  For other output formats, this markup
% is ignored.
%
% In an LaTeX document, this markup
%
%  <latex>
%  \begin{equation}
%  \begin{pmatrix}
%  1 & 2 \\ 3 & 4
%  \end{pmatrix}
%  \end{equation}
%  </latex>
%
% will print a nice matrix:
%
% <latex>
% \begin{equation}
% \begin{pmatrix}
% 1 & 2 \\ 3 & 4
% \end{pmatrix}
% \end{equation}
% </latex>
%
