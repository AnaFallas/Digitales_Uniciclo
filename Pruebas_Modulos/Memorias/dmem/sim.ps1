$env:Path = 'C:\intelFPGA\20.1\modelsim_ase\win32aloem;' + $env:Path

$REPO = Get-Location
$REPO = $REPO -replace "\\","/"
Write-Host $REPO

vlib work
vmap work work
vlog -sv dmem.sv dmem_tb.sv 
vsim -c -voptargs=+acc work.dmem_tb -do sim.do
vsim -view vsim.wlf
