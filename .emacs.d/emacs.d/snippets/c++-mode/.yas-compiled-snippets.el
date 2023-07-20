;;; Compiled snippets and support files for `c++-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c++-mode
		     '(("hheader" "// (c) Facebook, Inc. and its affiliates. Confidential and proprietary.\n\nnamespace facebook {\n\nclass $1 final { // : public BaseClass{\n public:\n  $1() = default;\n  explicit $1(singleArgument);\n  $1(const $1&) = delete;\n  $1& operator=(const $1 &) = delete;\n  ~$1 () = default;\n\n  virtual void() function() = 0;\n\n protected:\n   const function(args) const;\n private:\n\n} // namespace facebook\n" "hheader" nil nil
			((yas-indent-line 'fixed)
			 (yas-wrap-around-region 'nil))
			"/Users/gauglertodd/.emacs.d/snippets/c++-mode/hheader" nil nil)
		       ("cpi" "// (c) Facebook, Inc. and its affiliates. Confidential and proprietary.\n\n#include \"$1.hpp\"\n\nnamespace facebook {\n\n$2 $1::$3(){\n\n}\n\n} // namespace facebook\n" "cpi" nil nil
			((yas-indent-line 'fixed)
			 (yas-wrap-around-region 'nil))
			"/Users/gauglertodd/.emacs.d/snippets/c++-mode/cpp" nil nil)))


;;; Do not edit! File generated at Mon Sep 26 15:58:34 2022
