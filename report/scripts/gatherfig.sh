find experiments -name \*.eps -exec cp {} fig \;

# Crop white space from .eps files and generate .pdf files
cd fig
ps2pdf -DEPSCrop rint_mwe1a.eps rint_mwe1a.pdf
ps2pdf -DEPSCrop rint_mwe1b.eps rint_mwe1b.pdf
ps2pdf -DEPSCrop rint_mwe2a.eps rint_mwe2a.pdf
ps2pdf -DEPSCrop rint_mwe2b.eps rint_mwe2b.pdf
ps2pdf -DEPSCrop maxrange_rk1_tol11.eps maxrange_rk1_tol11.pdf
ps2pdf -DEPSCrop maxrange_rk1_tol18.eps maxrange_rk1_tol18.pdf
ps2pdf -DEPSCrop maxrange_rk1_tol53.eps maxrange_rk1_tol53.pdf
ps2pdf -DEPSCrop maxrange_rk2_tol11.eps maxrange_rk2_tol11.pdf
ps2pdf -DEPSCrop maxrange_rk2_tol25.eps maxrange_rk2_tol25.pdf
ps2pdf -DEPSCrop charmm36tol04.eps charmm36tol04.pdf
ps2pdf -DEPSCrop charmm36tol12.eps charmm36tol12.pdf
ps2pdf -DEPSCrop oplsaaltol04.eps oplsaaltol04.pdf
ps2pdf -DEPSCrop oplsaaltol12.eps oplsaaltol12.pdf
ps2pdf -DEPSCrop iontrap_mwe1.eps iontrap_mwe1.pdf
ps2pdf -DEPSCrop iontrap_mwe2.eps iontrap_mwe2.pdf
ps2pdf -DEPSCrop iontrap_mwe4.eps iontrap_mwe4.pdf
cd ..
