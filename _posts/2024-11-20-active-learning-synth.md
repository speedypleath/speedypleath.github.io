---
title: "Notes on active learning for sound synthesis control"
date: 2024-11-20
tags: [active learning, synthesis, notes]
description: Some thoughts on using active learning to reduce the annotation burden when building gesture-to-sound mappings.
---

Building gesture-to-sound mappings typically requires a lot of labelled data. Active learning strategies — where the model queries the user only for the most informative examples — can substantially reduce this burden. Here are some notes from experiments with query-by-committee on a small motion-capture dataset.
