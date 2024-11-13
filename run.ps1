$env:Path = 'C:\intelFPGA\20.1\modelsim_ase\win32aloem;' + $env:Path

$REPO = Get-Location
$REPO = $REPO -replace "\\","/"
Write-Host $REPO

vlib work
vmap work work
vlog -sv uni_tb.sv uni.sv 
vsim -c -voptargs=+acc work.uni_tb -do "add wave *; run -all; quit -f"
#vsim -view vsim.wlf