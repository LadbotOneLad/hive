# HIVE THETA LATTICE – 72 NODE QUANTUM ENGINE
# Pure PowerShell 5.1 – Newton + Kuramoto + Zha-field + Tron consensus

$N = 72
$K = 1.20

# Generate 72 nodes with random initial phases + intrinsic frequencies
$nodes = @()
for ($i = 0; $i -lt $N; $i++) {
    $nodes += @{
        Name  = "Node$i"
        Theta = (Get-Random -Minimum 0 -Maximum 6.28318)   # 0 to 2π
        Omega = (Get-Random -Minimum 0.05 -Maximum 0.15)   # intrinsic frequency
    }
}

function Step-Lattice {
    param([int]$steps)

    for ($t = 0; $t -lt $steps; $t++) {

        $dTheta = @()

        # Compute Δθ for each node
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

            # Newton/Kuramoto coupling:
            # Δθᵢ = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
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

        # Tron consensus: average |Δθ|
        $avgDelta = ($dTheta | ForEach-Object { [math]::Abs($_) } | Measure-Object -Average).Average

        Write-Host ""
        Write-Host ("=== t = {0} ===" -f $t)
        Write-Host ("Zha-field coherence r = {0:F3}" -f $r)
        Write-Host ("Tron consensus Δθ_avg = {0:F3}" -f $avgDelta)
        Write-Host ("Sample nodes:")
        for ($i = 0; $i -lt 10; $i++) {
            $n = $nodes[$i]
            Write-Host ("  {0,-10} θ={1,7:F3}" -f $n.Name, $n.Theta)
        }
    }
}

# Run 50 steps so they see real-time physics
Step-Lattice -steps 50
