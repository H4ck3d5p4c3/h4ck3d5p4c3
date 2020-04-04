$file = get-content .\Questions.txt


$Questions = @()

foreach ($line in $file) {
	
	
	if ($line -notmatch "Answer:.*") {
			$q += $line + "`n"
	}
	Else {
		$Questions += [pscustomobject]@{
			Question=$q;
			Answer=$line
		}
		$q = ""
	}
	
}
$TotalQuestions = $Questions.count

#function get-NumOfQuestions {
#	$NumQuestions = read-host -prompt "Please enter a number of questions"
#	if ($NumQuestions -notmatch "\d{1,3}") {
#		write-host "You did not enter a valid number in the correct range 1 - $TotalQuestions"
#		get-NumOfQuestions
#	}
#	elseif ([int]$NumQuestions -gt $TotalQuestions) {
#		write-host "You did not enter a valid number in the correct range 1 - $TotalQuestions"
#		get-NumOfQuestions
#	}
#}

$NumQuestions = read-host -prompt "Please enter a number of questions"

$CorrectCount = 0

foreach ($i in 1..$NumQuestions) {
	$n = get-random -maximum $($TotalQuestions - 1)
	write-host $Questions[$n].Question
	
	$givenAnswer = read-host -prompt "Please enter the correct Anwser"
	
	if ($Questions[$n].Answer[-2] -eq ",") {
		if ($Questions[$n].Answer[-4] -eq ",") {
			if ($givenAnswer -eq $Questions[$n].Answer.Substring($Questions[$n].Answer.get_length() - 5)) {
				write-host "You are correct" -Foregroundcolor Green
				$CorrectCount++
			}
			else {
				write-host "You are incorrect" -Foregroundcolor Red
			}
		}
		else {
			if ($givenAnswer -eq $Questions[$n].Answer.Substring($Questions[$n].Answer.get_length() - 3)) {
				write-host "You are correct" -Foregroundcolor Green
				$CorrectCount++
			}
			else {
				write-host "You are incorrect" -Foregroundcolor Red
			}
		}
	}
	else {
		if ($givenAnswer -eq $Questions[$n].Answer[-1]) {
			write-host "you are correct" -Foregroundcolor Green
			$CorrectCount++
		}
		else {
				write-host "You are incorrect" -Foregroundcolor Red
				write-host "The Correct"$Questions[$n].Answer  -Foregroundcolor yellow
			}
	}
}	

write-host "`n`n`n`n`n"
$score = $($CorrectCount/$NumQuestions)
write-host "You got $CorrectCount questions correct!"

If ($score -le .79) {
	write-host "You scored" $score.tostring("P") "on this exam and failed" -Foregroundcolor Red
}
else {
	write-host "You scored" $score.tostring("P") "on this exam and passed!" -Foregroundcolor Green
}
