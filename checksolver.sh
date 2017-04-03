#!/bin/bash
#Creates a temporary MPS file
#checks solver status by solving the mps and generate HTML output table
#Written by Alireza to check solver status
#https://coral.ise.lehigh.edu/solvers.html
echo "
NAME           
ROWS
 N  obj     
 L  c1      
 L  c2      
 G  c3      
 L  c4      
COLUMNS
    x1        obj                 -1   c1                  -1
    x1        c2                   1   c3                   3
    x2        obj                 -2   c1                   1
    x2        c2                  -3   c3                   2
    x3        obj                 -3   c1                   1
    x3        c2                   1   c3                  -1
    x3        c4                   1
    x4        c4                  -4
RHS
    rhs       c1                  20   c2                  30
    rhs       c3                 100   c4                  40
BOUNDS
 UP bnd       x1                  40
 LO bnd       x2                  10
 UP bnd       x3                 100
ENDATA" > /tmp/example.mps

export PATH=$PATH:/usr/local/cplex/bin/x86-64_linux/:/usr/local/gurobi/linux64/bin/:/usr/local/mosek/8/tools/platform/linux64x86/bin/
export LD_LIBRARY_PATH=/usr/local/gurobi/linux64/lib/

export GRB_LICENSE_FILE=/usr/local/gurobi/gurobi.lic
export GUROBI_HOME=/usr/local/gurobi/linux64
export MOSEKLM_LICENSE_FILE='/usr/local/mosek/8/licenses/mosek.lic'

CPX=`cplex -c read /tmp/example.mps opt | grep '\-202.5' | awk {'print $6'}`
GRB=`gurobi_cl /tmp/example.mps | grep '\-2.025' | grep Optimal | awk {'print $3'}`
MSK=`mosek /tmp/example.mps | grep '\-2.025' | grep Primal | grep 'con: 0e'  | awk {'print $3'}`

#cplex -c read /tmp/example.mps opt > /tmp/testcplex.txt 2>&1
#gurobi_cl /tmp/example.mps > /tmp/testgrb.txt 2>&1
#mosek /tmp/example.mps > /tmp/testmsk.txt 2>&1

sol[1]="DN" #$CPX
sol[2]="DN" #$GRB
sol[3]="DN" #$MSK
count=1
if [ -z "$CPX" ]; then sol[$count]="DN"; else sol[$count]="UP"; fi
let count+=1
if [ -z "$GRB" ]; then sol[$count]="DN"; else sol[$count]="UP"; fi
let count+=1
if [ -z "$MSK" ]; then sol[$count]="DN"; else sol[$count]="UP"; fi
let count+=1


for i in `seq 1 3`
do
    echo ${sol[$i]}
done

version[1]=`cplex <<< quit | fgrep Welcome | cut -d " " -f 8`
version[2]=`gurobi_cl --version | fgrep version | cut -d " " -f 4`
version[3]=`mosek| fgrep Version | cut -d " " -f 3`

echo -e "
Solver\t Version\t Status
CPLEX :\t ${version[1]}\t ${sol[1]}
GUROBI:\t ${version[2]}\t\t ${sol[2]}
MOSEK :\t ${version[3]}\t ${sol[3]}
" #> /tmp/solverstat.txt
timeofday=`date`
echo "
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}
.tg .tg-s6z2{text-align:center}
.tg .tg-baqh{text-align:center;vertical-align:top}
</style>
<center><font size=18 color=brown>COR@L Lab Solver Status</font></center><br><br><br>
<table class="tg" align="center">
  <tr>
    <th class="tg-s6z2">Solver</th>
    <th class="tg-baqh">Version</th>
    <th class="tg-baqh">Status</th>
  </tr>
  <tr>
    <td class="tg-baqh">CPLEX</td>
    <td class="tg-baqh">${version[1]}</td>
    <td class="tg-baqh">${sol[1]}</td>
  </tr>
  <tr>
    <td class="tg-baqh">GUROBI</td>
    <td class="tg-baqh">${version[2]}</td>
    <td class="tg-baqh">${sol[2]}</td>
  </tr>
  <tr>
    <td class="tg-baqh">MOSEK</td>
    <td class="tg-baqh">${version[3]}</td>
    <td class="tg-baqh">${sol[3]}</td>
  </tr>
</table><br><br>
<center>Last Checked: ${timeofday}<br>
" > /tmp/solvers.html
