find experiments -name \*.png -exec cp {} fig \;
find experiments -name \*.eps -exec cp {} fig \;

# Crop white space from MATLAB eps files
cd fig
ps2pdf -DEPSCrop charmm36tol04.eps charmm36tol04.pdf
ps2pdf -DEPSCrop charmm36tol12.eps charmm36tol12.pdf
ps2pdf -DEPSCrop oplsaaltol04.eps oplsaaltol04.pdf
ps2pdf -DEPSCrop oplsaaltol12.eps oplsaaltol12.pdf
cd ..
