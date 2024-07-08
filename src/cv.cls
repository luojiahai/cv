\ProvidesClass{cv}[]

\LoadClass[10pt,letterpaper]{article}

\usepackage[parfill]{parskip}       % Do not indent paragraphs
\usepackage{array}                  % required for boldface tabular columns
\usepackage[dvipsnames]{xcolor}
\usepackage{hyperref}

\nofiles                            % .aux files are not needed for resumes
\pagestyle{empty}                   % resumes do not need page numbers

\pagecolor{white}
\color{black}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADINGS: Commands for printing name and address
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def \name#1{\def\@name{#1}}        % \name command can be used to set name
\def \@name {}                      % Set \@name to empty by default

\def \addressSep {$\cdot$}          % Set default address seperator

% One or two address lines can be specified 
\let \@addressone \relax
\let \@addresstwo \relax

% \address command can be used to set first and second address (optional)
\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
    \def \@addressone {#1}
  }
}

% \printaddress is used to style an address line (given as input)
\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    #1
  \endgroup
  \par
  \addressskip
}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    {\namesize\bf \@name}\hfil
    \nameskip\break
  \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOCUMENT: Create the head of the document
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\let\ori@document=\document
\renewcommand{\document}{
  \ori@document                     % Begin document
  \printname                        % Print the name specified with \name
  \@ifundefined{@addressone}{}{     % Print the first address if specified
    \printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{     % Print the second address if specified
    \printaddress{\@addresstwo}}
}

\def\namesize{\Large}
\def\nameskip{\medskip}
\def\addressskip{\smallskip}
\def\sectionskip{\smallskip}
\def\sectionlineskip{\smallskip}
