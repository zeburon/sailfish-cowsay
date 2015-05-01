#ifndef FILELISTER_H
#define FILELISTER_H

#include <QObject>
#include <QStringList>

// -----------------------------------------------------------------------

class FileLister : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList filenames READ getFilenames NOTIFY signalFilenamesChanged)
    Q_PROPERTY(QString folder READ getFolder WRITE setFolder NOTIFY signalFolderChanged)
    Q_PROPERTY(QString filter READ getFilter WRITE setFilter NOTIFY signalFilterChanged)
public:
    explicit FileLister(QObject *parent = 0);
    virtual ~FileLister();

    const QStringList &getFilenames() const { return m_filenames; }
    void setFolder(const QString &folder);
    const QString &getFolder() const { return m_folder; }
    void setFilter(const QString &filter);
    const QString &getFilter() const { return m_filter; }

signals:
    void signalFilenamesChanged();
    void signalFolderChanged();
    void signalFilterChanged();

private:
    void updateFilenames();

    QStringList m_filenames;
    QString m_folder;
    QString m_filter;

};

// -----------------------------------------------------------------------

#endif // FILELISTER_H
