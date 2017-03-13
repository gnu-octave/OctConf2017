## Simple Examples
#
# The following chapters describe all of Octave's features in detail, but
# before doing that, it might be helpful to give a sampling of some of its
# capabilities.
#
# If you are new to Octave, we recommend that you try these examples to
# begin learning Octave by using it.  Lines marked like so,
# |>>|, are lines you type, ending each with a carriage
# return.  Octave will respond with an answer, or by displaying a graph.
#
##


## Elementary Calculations
#
# Octave can easily be used for basic numerical calculations.  Octave
# knows about arithmetic operations (|+|,|-|,|*|,|/|), exponentiation (|^|),
# natural logarithms/exponents (<octave:log log>, <octave:exp exp>), and the
# trigonometric functions (<octave:sin sin>, <octave:cos cos>, ...).  Moreover,
# Octave calculations work
# on real or imaginary numbers (i,j).  In addition, some mathematical
# constants such as the base of the natural logarithm (e) and the ratio
# of a circle's circumference to its diameter (<octave:pi pi>) are pre-defined.
# 
# For example, to verify Euler's Identity,
# $$e^{\imath\pi} = -1$$
#
# type the following which will evaluate to |-1| within the
# tolerance of the calculation.
#

exp (i*pi)


## Creating a Matrix
#
# Vectors and matrices are the basic building blocks for numerical
# analysis.  To create a new matrix and store it in a variable so that you
# can refer to it later, type the command
#

A = [ 1, 1, 2; 3, 5, 8; 13, 21, 34 ]

##
# Octave will respond by printing the matrix in neatly aligned columns.
# Octave uses a comma or space to separate entries in a row, and a
# semicolon or carriage return to separate one row from the next.
# Ending a command with a semicolon tells Octave not to print the result
# of the command.  For example,
#

B = rand (3, 2);

##
# will create a 3 row, 2 column matrix with each element set to a random
# value between zero and one.
#
# To display the value of a variable, simply type the name of the
# variable at the prompt.  For example, to display the value stored in the
# matrix |B|, type the command
#

B


## Matrix Arithmetic
#
# Octave uses standard mathematical notation with the advantage over
# low-level languages that operators may act on scalars, vector, matrices,
# or N-dimensional arrays.  For example, to multiply the matrix @code{A}
# by a scalar value, type the command
#

2 * A

##
# To multiply the two matrices |A| and |B|, type the command
#

A * B

##
# and to form the matrix product $A^T A$, type the command
#

A' * A


## Solving Systems of Linear Equations
#
# Systems of linear equations are ubiquitous in numerical analysis.
# To solve the set of linear equations $Ax = b$,
# use the left division operator, |\|:
#
#   x = A \ b
#
# This is conceptually equivalent to $x = A^{-1}b$,
# but avoids computing the inverse of a matrix directly.
#
# If the coefficient matrix is singular, Octave will print a warning
# message and compute a minimum norm solution.
#
# A simple example comes from chemistry and the need to obtain balanced
# chemical equations.  Consider the burning of hydrogen and oxygen to
# produce water.
#
# $$ {\rm H_{2}} + {\rm O_{2}} \rightarrow {\rm H_{2}O} $$
#
# The equation above is not accurate.  The Law of Conservation of Mass requires
# that the number of molecules of each type balance on the left- and right-hand
# sides of the equation.  Writing the variable overall reaction with
# individual equations for hydrogen and oxygen one finds:
#
# $$ x_{1}{\rm H_{2}} + x_{2}{\rm O_{2}} \rightarrow {\rm H_{2}O} $$
# $$ {\rm H:}\quad 2x_{1} + 0x_{2} \rightarrow 2 $$
# $$ {\rm O:}\quad 0x_{1} + 2x_{2} \rightarrow 1 $$
#
# The solution in Octave is found in just three steps.
#

A = [ 2, 0; 0, 2 ];
b = [ 2; 1 ];
x = A \ b


## Integrating Differential Equations
#
# Octave has built-in functions for solving nonlinear differential equations
# of the form $ {dx \over dt} = f(x,t)$, with the initial condition
# $x(t=t_0) = x_0$.
#
# For Octave to integrate equations of this form, you must first provide a
# definition of the function $f(x,t)$.
#
# This is straightforward, and may be accomplished by entering the
# function body directly on the command line.  For example, the following
# commands define the right-hand side function for an interesting pair of
# nonlinear differential equations.  Note that while you are entering a
# function, Octave responds with a different prompt, to indicate that it
# is waiting for you to complete your input.
#

function xdot = f (x, t)
  r = 0.25;
  k = 1.4;
  a = 1.5;
  b = 0.16;
  c = 0.9;
  d = 0.8;

  xdot(1) = r*x(1)*(1 - x(1)/k) - a*x(1)*x(2)/(1 + b*x(1));
  xdot(2) = c*a*x(1)*x(2)/(1 + b*x(1)) - d*x(2);
endfunction

##
# Given the initial condition
#

x0 = [1; 2];

##
# and the set of output times as a column vector (note that the first
# output time corresponds to the initial condition given above)
#

t = linspace (0, 50, 200)';

##
# it is easy to integrate the set of differential equations:
#

x = lsode ("f", x0, t);
x(1:2,:)

##
# The function <octave:lsode lsode> uses the Livermore Solver for Ordinary
# Differential Equations, described in A. C. Hindmarsh,
#
#  ODEPACK, a Systematized Collection of ODE Solvers, in: Scientific
#  Computing, R. S. Stepleman et al. (Eds.), North-Holland, Amsterdam,
#  1983, pages 55--64.
#


## Producing Graphical Output
#
# To display the solution of the previous example graphically, use the <octave:plot plot>
# command
#

plot (t, x)

##
# Octave will automatically create a separate window to display the plot.
#
# To save a plot once it has been displayed on the screen, use the <octave:print print>
# command.  For example,
#
#   print -dpdf foo.pdf
#
# will create a file called |foo.pdf| that contains a rendering of
# the current plot in Portable Document Format.  The command
#
#   help print
#
# explains more options for the <octave:print print> command and provides a list
# of additional output file formats.
#

plot (x, t)

## Help and Documentation
#
# Octave has an extensive help facility.  The same documentation that is
# available in printed form is also available from the Octave prompt,
# because both forms of the documentation are created from the same input
# file.
#
# In order to get good help you first need to know the name of the command
# that you want to use.  The name of this function may not always be
# obvious, but a good place to start is to type @code{help --list}.
# This will show you all the operators, keywords, built-in functions,
# and loadable functions available in the current session of Octave.  An
# alternative is to search the documentation using the <octave:lookfor lookfor>
# function (described in @ref{Getting Help}).
#
# Once you know the name of the function you wish to use, you can get more
# help on the function by simply including the name as an argument to help.
# For example,
#
#   help plot
#
# will display the help text for the @code{plot} function.
#
# Octave sends output that is too long to fit on one screen through a
# pager like |less| or |more|.  Type a |RET| to advance one
# line, a |SPC| to advance one page, and |q| to quit the pager.
#
# The part of Octave's help facility that allows you to read the complete
# text of the printed manual from within Octave normally uses a separate
# program called Info.  When you invoke Info you will be put into a menu
# driven program that contains the entire Octave manual.  Help for using
# Info is provided in this manual, @pxref{Getting Help}.
#


## Editing What You Have Typed
#
# At the Octave prompt, you can recall, edit, and reissue previous
# commands using Emacs- or vi-style editing commands.  The default
# keybindings use Emacs-style commands.  For example, to recall the
# previous command, press |Control-p| (written |C-p| for
# short).  Doing this will normally bring back the previous line of input.
# |C-n| will bring up the next line of input, |C-b| will move
# the cursor backward on the line, |C-f| will move the cursor forward
# on the line, etc.
#
# A complete description of the command line editing capability is given
# in this manual, @pxref{Command Line Editing}.
#
