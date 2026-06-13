using CampusConnect.Application.Interfaces;
using Hangfire;
using System;
using System.Linq.Expressions;

namespace CampusConnect.Infrastructure.Services
{
    public class HangfireBackgroundWorker : IBackgroundWorker
    {
        public void Enqueue<T>(Expression<Action<T>> methodCall)
        {
            BackgroundJob.Enqueue(methodCall);
        }
    }
}
