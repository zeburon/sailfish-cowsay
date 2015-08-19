#include "filelister.h"

#include <QDir>
#include <QUrl>

// -----------------------------------------------------------------------

FileLister::FileLister(QObject *parent) :
    QObject(parent), m_filter("*")
{
}

// -----------------------------------------------------------------------

FileLister::~FileLister()
{
}

// -----------------------------------------------------------------------

void FileLister::setFolder(const QString &folder)
{
    if (folder != m_folder)
    {
        m_folder = folder;
        emit signalFolderChanged();
        updateFilenames();
    }
}

// -----------------------------------------------------------------------

void FileLister::setFilter(const QString &filter)
{
    if (filter != m_filter)
    {
        m_filter = filter;
        emit signalFilterChanged();
        updateFilenames();
    }
}

// -----------------------------------------------------------------------

void FileLister::updateFilenames()
{
    QUrl url(m_folder);
    QString local_filename = url.toLocalFile();
    QDir dir(local_filename, m_filter, QDir::Name, QDir::Files);
    QStringList filenames = dir.entryList();
    if (filenames != m_filenames)
    {
        m_filenames = filenames;
        emit signalFilenamesChanged();
    }
}
