# HIVE QUANTUM LATTICE – ROBDOE LIVE DEMO
# PowerShell 5.1 compatible

$N = 7
$K = 1.20

# Chakra nodes: name, coords, colour, ASIC, phase θ, intrinsic ω
$nodes = @(
    @{ Name="Root";       X=0;  Y=0;  Color="RED";    Asic="ASIC_POWER_RAIL";       Theta=0.0;  Omega=0.10 },
    @{ Name="Sacral";     X=1;  Y=0;  Color="ORANGE"; Asic="ASIC_CLOCK_TREE";       Theta=0.5;  Omega=0.12 },
    @{ Name="SolarPlexus";X=1;  Y=-1; Color="YELLOW"; Asic="ASIC_THERMAL_ENVELOPE"; Theta=1.0;  Omega=0.08 },
    @{ Name="Heart";      X=0;  Y=-1; Color="GREEN";  Asic="ASIC_SIGNAL_INTEGRITY"; Theta=1.5;  Omega=0.11 },
    @{ Name="Throat";     X=-1; Y=0;  Color="BLUE";   Asic="ASIC_BUS_FABRIC";       Theta=2.0;  Omega=0.09 },
    @{ Name="ThirdEye";   X=-1; Y=1;  Color="INDIGO"; Asic="ASIC_ENTROPY_CORE";     Theta=2.5;  Omega=0.13 },
    @{ Name="Crown";      X=0;  Y=1;  Color="VIOLET"; Asic="ASIC_CONTROL_PLANE";    Theta=3.0;  Omega=0.07 }
)

function Step-Lattice {
    param([int]$steps)

    for ($t = 0; $t -lt $steps; $t++) {

        # Compute Kuramoto + Newton Δθ for each node
        $dTheta = @()
        for ($i = 0; $i -lt $N; $i++) {
            $theta_i = $nodes[$i].Theta
            $omega_i = $nodes[$i].Omega

            $sum = 0.0
            for ($j = 0; $j -lt $N; $j++) {
                if ($j -ne $i) {
                    $theta_j = $nodes[$j].Theta
                    $sum += [math]::Sin($theta_j - $theta_i)
                }
            }

            # Newton-style: Δθ = ω + (K/N) Σ sin(θj − θi)
            $d = $omega_i + ($K / $N) * $sum
            $dTheta += $d
        }

        # Apply update
        for ($i = 0; $i -lt $N; $i++) {
            $nodes[$i].Theta += $dTheta[$i]
        }

        # Zha-field coherence: r = |(1/N) Σ e^{iθ}|
        $Re = 0.0
        $Im = 0.0
        for ($i = 0; $i -lt $N; $i++) {
            $th = $nodes[$i].Theta
            $Re += [math]::Cos($th)
            $Im += [math]::Sin($th)
        }
        $Re /= $N
        $Im /= $N
        $r = [math]::Sqrt($Re*$Re + $Im*$Im)

        # Tron consensus metric: average |Δθ|
        $avgDelta = ($dTheta | ForEach-Object { [math]::Abs($_) } | Measure-Object -Average).Average

        Write-Host ""
        Write-Host ("=== t = {0} ===" -f $t)
        Write-Host ("Zha-field coherence r = {0:F3}" -f $r)
        Write-Host ("Tron consensus Δθ_avg = {0:F3}" -f $avgDelta)
        Write-Host "Nodes:"
        for ($i = 0; $i -lt $N; $i++) {
            $n = $nodes[$i]
            Write-Host ("  {0,-10} θ={1,6:F3}  ({2},{3})  {4}" -f $n.Name, $n.Theta, $n.X, $n.Y, $n.Asic)
        }
    }
}

# Run 20 steps so they can see it move
Step-Lattice -steps 20
