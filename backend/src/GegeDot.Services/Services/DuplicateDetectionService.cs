using GegeDot.Core.Entities;
using GegeDot.Core.Interfaces;
using GegeDot.Services.Interfaces;

namespace GegeDot.Services.Services;

/// <summary>
/// Service de détection de doublons pour éviter les enregistrements multiples
/// </summary>
public class DuplicateDetectionService : IDuplicateDetectionService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly double _defaultSimilarityThreshold = 0.85;

    public DuplicateDetectionService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    /// <summary>
    /// Trouve les doublons potentiels pour une personne
    /// </summary>
    public async Task<List<DuplicateCandidate>> FindDuplicatesAsync(Person person)
    {
        var candidates = new List<DuplicateCandidate>();
        var allPersons = await _unitOfWork.Persons.GetAllAsync();

        foreach (var existingPerson in allPersons)
        {
            // Ignorer la personne elle-même si elle a déjà un ID
            if (person.Id > 0 && existingPerson.Id == person.Id)
                continue;

            var similarityScore = CalculateSimilarityScore(person, existingPerson);

            if (similarityScore >= _defaultSimilarityThreshold)
            {
                var matchReason = DetermineMatchReason(person, existingPerson, similarityScore);

                candidates.Add(new DuplicateCandidate
                {
                    PersonId = existingPerson.Id,
                    FullName = existingPerson.FullName,
                    BirthDate = existingPerson.BirthDate,
                    BirthPlace = existingPerson.BirthPlace,
                    SimilarityScore = similarityScore,
                    MatchReason = matchReason
                });
            }
        }

        return candidates
            .OrderByDescending(c => c.SimilarityScore)
            .ToList();
    }

    /// <summary>
    /// Vérifie si deux personnes sont des doublons
    /// </summary>
    public bool IsDuplicate(Person person1, Person person2, double threshold = 0.85)
    {
        var score = CalculateSimilarityScore(person1, person2);
        return score >= threshold;
    }

    /// <summary>
    /// Calcule le score de similarité entre deux personnes
    /// </summary>
    public double CalculateSimilarityScore(Person person1, Person person2)
    {
        var nameScore = CalculateNameSimilarity(person1, person2);
        var dateScore = CalculateDateSimilarity(person1, person2);
        var placeScore = CalculatePlaceSimilarity(person1, person2);

        // Poids : Nom 50%, Date 30%, Lieu 20%
        return (nameScore * 0.5) + (dateScore * 0.3) + (placeScore * 0.2);
    }

    /// <summary>
    /// Calcule la similarité des noms
    /// </summary>
    private double CalculateNameSimilarity(Person p1, Person p2)
    {
        var fullName1 = $"{p1.FirstName} {p1.LastName}".ToLowerInvariant().Trim();
        var fullName2 = $"{p2.FirstName} {p2.LastName}".ToLowerInvariant().Trim();

        if (fullName1 == fullName2)
            return 1.0;

        // Similarité de Levenshtein
        var distance = LevenshteinDistance(fullName1, fullName2);
        var maxLength = Math.Max(fullName1.Length, fullName2.Length);

        if (maxLength == 0)
            return 1.0;

        var similarity = 1.0 - (double)distance / maxLength;

        // Bonus si les prénoms ou noms sont identiques
        if (p1.FirstName.Equals(p2.FirstName, StringComparison.OrdinalIgnoreCase))
            similarity += 0.1;
        if (p1.LastName.Equals(p2.LastName, StringComparison.OrdinalIgnoreCase))
            similarity += 0.1;

        return Math.Min(1.0, similarity);
    }

    /// <summary>
    /// Calcule la similarité des dates de naissance
    /// </summary>
    private double CalculateDateSimilarity(Person p1, Person p2)
    {
        if (!p1.BirthDate.HasValue || !p2.BirthDate.HasValue)
            return 0.0;

        var diff = Math.Abs((p1.BirthDate.Value - p2.BirthDate.Value).TotalDays);

        // Tolérance de 30 jours = 100% de similarité
        if (diff <= 30)
            return 1.0;

        // Tolérance de 1 an = 80% de similarité
        if (diff <= 365)
            return 0.8;

        // Tolérance de 10 ans = 50% de similarité
        if (diff <= 3650)
            return 0.5;

        // Même année = 30% de similarité
        if (p1.BirthDate.Value.Year == p2.BirthDate.Value.Year)
            return 0.3;

        return 0.0;
    }

    /// <summary>
    /// Calcule la similarité des lieux de naissance
    /// </summary>
    private double CalculatePlaceSimilarity(Person p1, Person p2)
    {
        if (string.IsNullOrWhiteSpace(p1.BirthPlace) || string.IsNullOrWhiteSpace(p2.BirthPlace))
            return 0.0;

        var place1 = p1.BirthPlace.ToLowerInvariant().Trim();
        var place2 = p2.BirthPlace.ToLowerInvariant().Trim();

        if (place1 == place2)
            return 1.0;

        // Similarité de Levenshtein pour les lieux
        var distance = LevenshteinDistance(place1, place2);
        var maxLength = Math.Max(place1.Length, place2.Length);

        if (maxLength == 0)
            return 1.0;

        return 1.0 - (double)distance / maxLength;
    }

    /// <summary>
    /// Calcule la distance de Levenshtein entre deux chaînes
    /// </summary>
    private int LevenshteinDistance(string s1, string s2)
    {
        if (string.IsNullOrEmpty(s1))
            return string.IsNullOrEmpty(s2) ? 0 : s2.Length;

        if (string.IsNullOrEmpty(s2))
            return s1.Length;

        var matrix = new int[s1.Length + 1, s2.Length + 1];

        // Initialisation
        for (int i = 0; i <= s1.Length; i++)
            matrix[i, 0] = i;

        for (int j = 0; j <= s2.Length; j++)
            matrix[0, j] = j;

        // Calcul
        for (int i = 1; i <= s1.Length; i++)
        {
            for (int j = 1; j <= s2.Length; j++)
            {
                var cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
                matrix[i, j] = Math.Min(
                    Math.Min(matrix[i - 1, j] + 1, matrix[i, j - 1] + 1),
                    matrix[i - 1, j - 1] + cost);
            }
        }

        return matrix[s1.Length, s2.Length];
    }

    /// <summary>
    /// Détermine la raison de la correspondance
    /// </summary>
    private string DetermineMatchReason(Person person, Person existingPerson, double score)
    {
        var reasons = new List<string>();

        if (person.FirstName.Equals(existingPerson.FirstName, StringComparison.OrdinalIgnoreCase) &&
            person.LastName.Equals(existingPerson.LastName, StringComparison.OrdinalIgnoreCase))
        {
            reasons.Add("Nom identique");
        }

        if (person.BirthDate.HasValue && existingPerson.BirthDate.HasValue)
        {
            var dateDiff = Math.Abs((person.BirthDate.Value - existingPerson.BirthDate.Value).TotalDays);
            if (dateDiff <= 30)
                reasons.Add("Date de naissance similaire");
        }

        if (!string.IsNullOrWhiteSpace(person.BirthPlace) &&
            !string.IsNullOrWhiteSpace(existingPerson.BirthPlace) &&
            person.BirthPlace.Equals(existingPerson.BirthPlace, StringComparison.OrdinalIgnoreCase))
        {
            reasons.Add("Lieu de naissance identique");
        }

        if (reasons.Count == 0)
            return $"Similarité globale: {score:P0}";

        return string.Join(", ", reasons);
    }
}
