{ obsidian-skills }:

{
  # -------------------------------------------------------------------------
  # Agents
  # Add entries as: name = "${some-input}/agents/name.agent.md";
  # -------------------------------------------------------------------------
  agents = { };

  # -------------------------------------------------------------------------
  # Skills
  # Local: reference a path relative to this file (directory with SKILL.md)
  # External: "${input}/path/to/skill-dir"
  # -------------------------------------------------------------------------
  skills = {
    # Local skills
    powerbi-modeling = ./skills/powerbi-modeling;
    powerbi-sql      = ./skills/powerbi-sql;

    # kepano/obsidian-skills
    defuddle         = "${obsidian-skills}/skills/defuddle";
    json-canvas      = "${obsidian-skills}/skills/json-canvas";
    obsidian-bases   = "${obsidian-skills}/skills/obsidian-bases";
    obsidian-cli     = "${obsidian-skills}/skills/obsidian-cli";
    obsidian-markdown = "${obsidian-skills}/skills/obsidian-markdown";
  };
}
