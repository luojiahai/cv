\ProvidesClass{xsha}[]
\LoadClass[10pt,letterpaper]{article}
\AddToHook{package/xeCJK/after}{\defaultCJKfontfeatures{}}

\usepackage{xeCJK}
\usepackage{fontspec}
\setmainfont{Times New Roman}
\setCJKmainfont[
Extension={.otf},
BoldFont={FandolSong-Bold},
ItalicFont={FandolKai-Regular}
]{FandolSong-Regular}

\usepackage[parfill]{parskip}
\usepackage{array}
\usepackage[dvipsnames]{xcolor}
\usepackage{hyperref}
\usepackage[left=0.3in,top=0.3in,right=0.3in,bottom=0.3in]{geometry}

\pagestyle{empty}
\pagecolor{white}
\color{black}

\def\namesize{\LARGE}
\def\nameskip{\medskip}
\def\addressskip{\smallskip}
\def\sectionskip{\smallskip}
\def\sectionlineskip{\smallskip}

\newcommand{\name}[1]{
\begingroup
{\namesize\bf #1}\hfil
\nameskip\break
\endgroup
}

\newcommand{\address}[1]{
\begingroup
#1
\endgroup
\par\addressskip
}

\newenvironment{xsection}[1]{
\textbf{\uppercase{#1}}
\sectionlineskip
\hrule height 0.6pt
\begin{list}{}{\setlength{\leftmargin}{0pt}}
\vspace{2.0pt}
\itemsep -2.0pt
}{\end{list}\sectionskip}

\newenvironment{xheading1}[2]{
\item \textbf{#1} \hfill \textbf{#2}
\begin{list}{}{\setlength{\leftmargin}{0pt}}
\vspace{-4.0pt}
\itemsep -4.0pt
}{\end{list}\vspace{1.0pt}}

\newenvironment{xheading2}[2]{
\item \textbf{#1} \hfill {#2}
\begin{list}{\raisebox{2.0pt}{\tiny$\bullet$}\space}{\setlength{\leftmargin}{12.0pt}}
\vspace{-4.0pt}
\itemsep -4.0pt
}{\end{list}\vspace{1.0pt}}

\newenvironment{xheading3}[2]{
\item \textbf{#1} \hfill {#2}
\par
}{\vspace{1.0pt}}

\newenvironment{xheading4}[1]{
\item \textbf{#1}:
}{\vspace{1.0pt}}

\newenvironment{xsubheading1}[2]{
\item \textit{#1} \hfill {#2}
\begin{list}{\raisebox{2.0pt}{\tiny$\bullet$}\space}{\setlength{\leftmargin}{12.0pt}}
\vspace{-4.0pt}
\itemsep -4.0pt
}{\end{list}\vspace{1.0pt}}

\newenvironment{xsubheading2}[2]{
\item \textit{#1} \hfill {#2}
\par
}{\vspace{1.0pt}}
