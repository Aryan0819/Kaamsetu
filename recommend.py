def recommend_jobs(user_skills, all_jobs):
    """Simple job recommendation based on skill matching"""
    recommendations = []
    for job in all_jobs:
        job_skills = [s.strip().lower() for s in job.skill_required.split(",")]
        user_skills_lower = [s.lower() for s in user_skills]
        matching = set(job_skills).intersection(set(user_skills_lower))
        if matching:
            score = len(matching) / len(job_skills) * 100
            recommendations.append({
                "job": job,
                "score": round(score, 2),
                "matching_skills": list(matching)
            })
    return sorted(recommendations, key=lambda x: x["score"], reverse=True)
