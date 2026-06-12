using System.Linq.Expressions;

namespace CampusConnect.Application.Interfaces
{
    public interface IBackgroundWorker
    {
        void Enqueue<T>(Expression<Action<T>> methodCall);
    }
}
