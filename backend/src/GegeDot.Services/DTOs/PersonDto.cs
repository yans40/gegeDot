namespace GegeDot.Services.DTOs;

public class PersonDto
{
    public int Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    public string? BirthPlace { get; set; }
    public string? DeathPlace { get; set; }
    public string? Profession { get; set; }
    public DateTime? MarriageDate { get; set; }
    public string? MarriagePlace { get; set; }
    public string? DeathStatus { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Biography { get; set; }
    public string Gender { get; set; } = "M";
    public bool IsAlive { get; set; } = true;
    public string FullName { get; set; } = string.Empty;
    public int? Age { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class CreatePersonDto
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    public string? BirthPlace { get; set; }
    public string? DeathPlace { get; set; }
    public string? Profession { get; set; }
    public DateTime? MarriageDate { get; set; }
    public string? MarriagePlace { get; set; }
    public string? DeathStatus { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Biography { get; set; }
    public string Gender { get; set; } = "M";
    public bool IsAlive { get; set; } = true;
    public int? Parent1Id { get; set; }
    public int? Parent2Id { get; set; }
}

public class UpdatePersonDto
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    public string? BirthPlace { get; set; }
    public string? DeathPlace { get; set; }
    public string? Profession { get; set; }
    public DateTime? MarriageDate { get; set; }
    public string? MarriagePlace { get; set; }
    public string? DeathStatus { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Biography { get; set; }
    public string Gender { get; set; } = "M";
    public bool IsAlive { get; set; } = true;
}
