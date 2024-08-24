\ProvidesClass{cv}[]
\LoadClass[10pt,letterpaper]{article}

\usepackage[parfill]{parskip}
\usepackage{array}
\usepackage[dvipsnames]{xcolor}
\usepackage{hyperref}
\usepackage[left=0.3in,top=0.3in,right=0.3in,bottom=0.3in]{geometry}
\usepackage{times}

\nofiles
\pagestyle{empty}
\pagecolor{white}
\color{black}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Headings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def \name #1{\def\@name{#1}}
\def \@name {}
\def \address #1{\def\@address{#1}}
\def \@address {}

% print address
\def \printaddress {
  \begingroup
    \@address
  \endgroup
  \par
  \addressskip
}

% print name
\def \printname {
  \begingroup
    {\namesize\bf \@name}\hfil
    \nameskip\break
  \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Document
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\let\original@document=\document
\renewcommand{\document}{
  \original@document
  \printname
  \printaddress
}

\def\namesize{\Large}
\def\nameskip{\medskip}
\def\addressskip{\smallskip}
\def\sectionskip{\smallskip}
\def\sectionlineskip{\smallskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom commands and environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\cvsection}[1]{
\textbf{\uppercase{#1}}
\sectionlineskip
\hrule height 0.6pt
}

\newenvironment{cvlist}[1][0pt]{
\begin{list}{}{\setlength{\leftmargin}{0pt}}
\itemsep #1
}{\end{list}\sectionskip}

\newenvironment{cvheading}[2]{
\item
\textbf{#1} \hfill \textbf{#2}%
\vspace{1.0pt} \newline
\begin{list}{}{\setlength{\leftmargin}{0pt}}
\itemsep -2.0pt \vspace{-16.0pt}
}{\end{list}}

\newenvironment{cvsubheading}[2]{
\item
{\textit{#1}} \hfill {#2}%
\begin{list}{\raisebox{2.0pt}{\tiny$\bullet$}\space}{\setlength{\leftmargin}{12.0pt}}
\itemsep -4.0pt \vspace{-4.0pt}
}{\end{list}}

\newenvironment{cvlistitem}[1]{\item \textbf{#1}:}{}
