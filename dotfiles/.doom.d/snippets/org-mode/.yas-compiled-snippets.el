;;; Compiled snippets and support files for `org-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'org-mode
                     '(("pyc" "#+begin_src python :tangle yes\n$0\n#+end_src" "python-code-block" nil nil nil "/home/lford/.doom.d/snippets/org-mode/python-code-block" nil nil)
                       ("cfig" "\\hspace*{-1cm}\n\\includegraphics[width=1.15\\linewidth,height=1.15\\textheight,keepaspectratio]{\"${1:path-to-figure}\"}\n" "beamer-figure" nil nil nil "/home/lford/.doom.d/snippets/org-mode/beamer-figure-more-custom" nil nil)
                       ("bfig" "\\includegraphics[height=0.95\\textheight,keepaspectratio]{\"${1:path-to-figure}\"}\n" "beamer-figure" nil nil nil "/home/lford/.doom.d/snippets/org-mode/beamer-figure" nil nil)))


;;; Do not edit! File generated at Wed Apr 27 08:03:02 2022
