# ODDI-C Algorithm and its Numerical Validations

## BACKGROUND:
Opinion Dynamics-inspired DIsruption-tolerant Consensus (ODDI-C) is distributed dynamic consensus algorithm for static directed multi-agent networks dealing with unknown disruptors.  ODDI-C is implemented by cooperative system nodes and enables them to reach a resilient consensus without the need for a central authority, in spite of the presence of disruptors. The algorithm requires no information regarding network topology nor the number and behaviours of the disruptors.  

The algorithm adapts the concept of tolerance from social systems, using an analogous approach to the Deffuant Model for its update and filtering. By inverting typical social tolerance, agents filter out extremist non-standard opinions that would drive them away from consensus. This approach allows distributed systems to deal with unknown disruptions, without knowledge of the network topology or the numbers and behaviours of the disruptors. A disruptor-agnostic algorithm is particularly suitable to real-world applications where this information is typically unknown. Faster and tighter convergence can be achieved across a range of scenarios with the social dynamics inspired algorithm, compared with standard Mean-Subsequence-Reduced (MSR)-type methods.

## CONTENTS: 
This repository contains the implementation of ODDI-C, as well as three numerical simulations showcasing its performance. The simulations include:
- **single_run**: looks at the performance of ODDI-C (and other filters) for a specific network against specified disruptors. Focus is given to the opinion/state value trajectories of the network nodes over time. A convergence metric provides insight on the convergence process.   
- **edge_test_connections**: investigates the impact of increasing network ndoes' connectivity on algorithm performance. Monte Carlo simulations are used to to extract general trends from the simulated scenarios. The results of each connectivity level are shown using the convergence metric, averaged over the Monte Carlo simulation length. ODDI-C's performance can be compared with an implementation of the classical MSR method [1]. 
- **edge_test_breakpoint**: investigates ODDI-C's performance degration as the number of disruptors in the systems increases. Each disruptor number is computed as a Monte Carlo Monte simulations to ensure the applicability of the extracted trends. The results of each batch are shown using the convergence metric, averaged over the Monte Carlo simulation length. ODDI-C's performance can be compared with an implementation of the classical MSR method [1]. 

Remaining code in the repository act as functions to enable the running of the three simulations. Details of ODDI-C are found in the "filter_ODDI_C" code, which is run in conjunction with the "update_script".

Credit to [1], LeBlanc et al. (2013), Resilient Asymptotic Consensus in Robust Networks. IEEE Journal on Selected Areas in Communications, for their MSR implementation. 

## PROJECT STATUS: 
Development slowed. 

## AUTHORS and ACKNOWLEDGEMENT:
Agathe BOUIS with acknowledgements to the Applied Space Technology Laboratory (ApSTL) group at the University of Strathclyde, including Dr. Astrid Werkmeister, Joshua Gribben, Dr. Ruaridh Clark, and Prof. Malcolm Macdonald. 
