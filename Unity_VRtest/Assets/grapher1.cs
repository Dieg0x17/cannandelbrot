﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class grapher1 : MonoBehaviour {

    public int resolution = 10;

    private int currentResolution;
    private ParticleSystem.Particle[] points;

    void Start()
    {
        CreatePoints();
    }

    private void CreatePoints()
    {
        if (resolution < 10 || resolution > 100)
        {
            Debug.LogWarning("Grapher resolution out of bounds, resetting to minimum.", this);
            resolution = 10;
        }
        currentResolution = resolution;
        points = new ParticleSystem.Particle[resolution];
        float increment = 1f / (resolution - 1);
        for (int i = 0; i < resolution; i++)
        {
            float x = i * increment;
            points[i].position = new Vector3(x, 0f, 0f);
            points[i].color = new Color(x, 0f, 0f);
            points[i].size = 0.1f;
        }
    }

    void Update()
    {
        if (currentResolution != resolution)
        {
            CreatePoints();
        }
        GetComponent<ParticleSystem>().SetParticles(points, points.Length);
    }
}