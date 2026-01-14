# --- Your original setup ---
set search_path "./"
set link_library ""
set_app_var enable_lint true

# --- Your original rules ---
configure_lint_tag -enable -tag "W241" -goal lint_rtl  
configure_lint_tag -enable -tag "W240" -goal lint_rtl 

# --- Adding more critical rules ---
configure_lint_tag -enable -tag "W110" -goal lint_rtl 
configure_lint_tag -enable -tag "W116" -goal lint_rtl  
configure_lint_tag -enable -tag "W121" -goal lint_rtl 
configure_lint_tag -enable -tag "W415A" -goal lint_rtl 
configure_lint_tag -enable -tag "W372" -goal lint_rtl 
configure_lint_tag -enable -tag "W438" -goal lint_rtl 

configure_lint_setup -goal lint_rtl

# --- Your original run commands ---
analyze -verbose -format verilog "GHR.v"
elaborate GHR 
check_lint
report_lint -verbose -file GHR_lint.txt
