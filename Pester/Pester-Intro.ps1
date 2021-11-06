function Play-Name {

    param(

        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName
                   )]
        [string]$Name

    )

    $Title = (Get-Culture).TextInfo.ToTitleCase($Name)

    $Title

}

describe "play name title cases name" {

    it "Title cases name"{

        Play-Name -Name "ben hollamby" | Should -Be "Ben Hollamby"

    }

    it "Title cases name"{

        Play-Name -Name "Ben hollamby" | Should -Be "Ben Hollamby"

    }

    it "Title cases name"{

        Play-Name -Name "ben Hollamby" | Should -Be "Ben Hollamby"

    }

    it "Title cases name"{

        Play-Name -Name "Ben Hollamby" | Should -Be "Ben Hollamby"

    }

    it "type should be string" {

        Play-Name -Name "Ben Hollamby" | Should -BeOfType 'System.String'

    }

    it "should not be empty" {

        Play-Name -Name "Ben Hollamby" | Should -not -BeNullOrEmpty

    }

}

describe "parameter takes a string and is mandatory" {

    it "has a parameter of name and is mandatory" {

        Get-Command -Name Play-Name  | Should -HaveParameter 'Name' -Mandatory

    }

}